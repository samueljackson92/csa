require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
    create_dummy_session :one
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
end
