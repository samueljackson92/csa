require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = create_dummy_session :one
  end

  teardown do
    destroy_dummy_session
  end

  test "should search for user" do
    get :search, q: 'loftus'
    assert_response :success
    assert_template :index
  end

  test "should search for user using json" do
    get :search, format: 'json', q: 'loftus'
    assert_response :success

    users = JSON.parse(@response.body)
    assert_equal 1, users.length
    assert_equal 'Loftus', users[0]["surname"]
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get index with json" do
    get :index, format: 'json'

    users = JSON.parse(@response.body)
    assert_response :success
    assert_equal 4, users.length, "Expected number of users does not match"
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: { email: @user.email + 's',
                            firstname: @user.firstname,
                            grad_year: @user.grad_year,
                            jobs: @user.jobs,
                            phone: @user.phone,
                            surname: @user.surname }
    end

    assert_redirected_to "#{user_path(assigns(:user))}?page=1"
  end

  test "should fail to create user" do
    assert_no_difference('User.count') do
      post :create, user: { email: @user.email,
                            firstname: @user.firstname,
                            grad_year: 1900,
                            jobs: @user.jobs,
                            phone: @user.phone,
                            surname: @user.surname }
    end

    #just renders the new user view
    assert_response :success
    assert_template :new
  end

  test "should fail to create user with json response" do
    assert_no_difference('User.count') do
      post :create, format: 'json', user: { email: @user.email,
                                            firstname: @user.firstname,
                                            grad_year: 1900,
                                            jobs: @user.jobs,
                                            phone: @user.phone,
                                            surname: @user.surname }
    end

    assert_response :unprocessable_entity
    errors = JSON.parse(@response.body)

    assert_equal 2, errors.length
    assert_equal 1, errors["grad_year"].length
    assert_equal 1, errors["email"].length
    assert_equal "must be greater than or equal to 1970", errors["grad_year"][0]
    assert_equal "has already been taken", errors["email"][0]
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should not show user" do
    #admins can see everyone by default.
    #change user id for this test
    create_dummy_session :two
    get :show, id: @user
    assert_redirected_to home_url
  end

  test "should recover from not finding a user" do
    get :show, id: -1
    assert_redirected_to users_url(page: 1)
  end

  test "should recover from not finding a user with JSON request" do
    get :show, format: 'json', id: -1

    json_response = JSON.parse(@response.body)
    assert_response :unprocessable_entity
    assert_equal "Account no longer exists", json_response["message"]
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should not be able to edit another users account " do
    #admins can see everyone by default.
    #change user id for this test
    create_dummy_session :two
    get :edit, id: @user
    assert_redirected_to home_url
  end

  test "should not be able to edit another users account with json response" do
    #admins can see everyone by default.
    #change user id for this test
    create_dummy_session :two
    get :edit, format: 'json', id: @user
    assert_response :unprocessable_entity
    error = JSON.parse(@response.body)
    assert_equal "This is not your account, access denied", error["message"]
  end

  test "should be able to edit account if admin" do
    get :edit, id: users(:two)
    assert_response :success
  end

  test "should update user" do
    patch :update, id: @user, user: { email: @user.email,
                                      firstname: @user.firstname,
                                      grad_year: @user.grad_year,
                                      jobs: @user.jobs,
                                      phone: @user.phone,
                                      surname: @user.surname }

    assert_redirected_to "#{user_path(assigns(:user))}?page=1"
  end

  test "should fail to update user" do
    patch :update, id: @user, user: { email: '',
                                      firstname: @user.firstname,
                                      grad_year: @user.grad_year,
                                      jobs: @user.jobs,
                                      phone: @user.phone,
                                      surname: @user.surname }

    assert_response :success
    assert_template :edit
  end

  test "should fail to update user with json response" do
    patch :update, format: 'json', id: @user, user: { email: '',
                                      firstname: @user.firstname,
                                      grad_year: @user.grad_year,
                                      jobs: @user.jobs,
                                      phone: @user.phone,
                                      surname: @user.surname }

    assert_response :unprocessable_entity
    errors = JSON.parse(@response.body)
    assert_equal 1, errors.length
    assert_equal 2, errors["email"].length

    assert_equal "can't be blank", errors["email"][0]
    assert_equal "Bad email address format", errors["email"][1]
  end

  test "should not be able to update another users account " do
    #admins can see everyone by default.
    #change user id for this test
    create_dummy_session :two
    patch :update, id: @user, user: { email: @user.email,
                                      firstname: @user.firstname,
                                      grad_year: @user.grad_year,
                                      jobs: @user.jobs,
                                      phone: @user.phone,
                                      surname: @user.surname }
    assert_redirected_to home_url
  end

  test "should be able to update account if admin" do
    other_user = users(:two)
    patch :update, id: other_user, user: { email: other_user.email,
                                           firstname: other_user.firstname,
                                           grad_year: other_user.grad_year,
                                           jobs: other_user.jobs,
                                           phone: other_user.phone,
                                           surname: other_user.surname }

    assert_redirected_to "#{user_path(assigns(:user))}?page=1"
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to "#{users_path}?page=1"
  end

  test "should fail to perform action for regular user admin action" do
    # ignore session setup before test
    @user = create_dummy_session :two
    another_user = users(:three)
    get :index, id: another_user
    assert_redirected_to root_url
  end

  test "should show locale in cymraeg" do
    get :index, id: @user, locale: 'cw'
    assert_response :success
  end

  test "should recover from unknown locale" do
    get :index, id: @user, locale: 'fr'
    assert_response :success
  end

  ###############################################
  # JSON API access tests
  ###############################################

  test "should verify user can login" do
    destroy_dummy_session
    @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("admin:taliesin")
    get :verify, format: 'json'

    assert_response :success
    json_response = JSON.parse(@response.body)
    assert_equal 980190962, json_response["id"], "User id should match expected"
  end

  test "should unauthorized user can't verify login" do
    destroy_dummy_session
    @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("admin:not_a_password")
    get :verify, format: 'json'
    assert_response :unauthorized
  end

  ###############################################
  # Authentication tests
  ###############################################

  test "should authenticate using HTTP auth" do
    # ignore session setup before test
    session[:user_id] = nil

    @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("admin:taliesin")
    get :show, id: @user
    assert_response :success
  end

  test "should fail to authenticate via HTTP auth" do
    # ignore session setup before test
    session[:user_id] = nil

    @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("admin:not_a_password")
    get :show, id: @user
    assert_redirected_to new_session_path
  end

  test "should fail to authenticate via HTTP auth via json" do
    # ignore session setup before test
    session[:user_id] = nil

    @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("admin:not_a_password")
    get :show, id: @user, format: 'json'
    assert_response :unauthorized
  end
end
