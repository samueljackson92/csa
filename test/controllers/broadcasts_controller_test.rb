require 'test_helper'

class BroadcastsControllerTest < ActionController::TestCase
  setup do
    @broadcast = broadcasts(:one)
    create_dummy_session :one
  end

  teardown do
      destroy_dummy_session
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:broadcasts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create broadcast" do
    assert_difference('Broadcast.count') do
      post :create, broadcast: { content: create_timestampped_broadcast(@broadcast.content).content, user_id: @broadcast.user_id}, feeds: ["RSS"]
    end

    assert_redirected_to broadcasts_url(page: 1)
  end

  test "should create broadcast with json response" do
    assert_difference('Broadcast.count') do
      post :create, format: 'json', broadcast: { content: create_timestampped_broadcast(@broadcast.content).content, user_id: @broadcast.user_id}, feeds: ["RSS"]
    end

    assert_response :created
  end

  test "should fail to create broadcast" do
    #send a large tweet to the server, with will cause and error to occur.
    post :create, broadcast: { content: create_large_tweet, user_id: @broadcast.user_id}, feeds: ["twitter"]
    assert_template :new
  end

  test "should fail to create broadcast with json" do
    #send a large tweet to the server, with will cause and error to occur.
    post :create, format: 'json', broadcast: { content: create_large_tweet, user_id: @broadcast.user_id}, feeds: ["twitter"]
    assert_response :created
  end

  test "should show broadcast" do
    get :show, id: @broadcast
    assert_response :success
  end

  test "should fail to show broadcast" do
    get :show, id: -1
    assert_redirected_to broadcasts_path
  end

  test "should fail to show broadcast with json response" do
    get :show, id: -1, format: 'json'
    assert_response :no_content
  end

  test "should destroy broadcast" do
    assert_difference('Broadcast.count', -1) do
      delete :destroy, id: @broadcast
    end

    assert_redirected_to broadcasts_path
  end

  test "should search for broadcast" do
    get :search, q: 'wibble'
    assert_response :success
    assert_template :index
  end

  test "should search for broadcast using json" do
    get :search, format: 'json', q: 'wibble'
    assert_response :success

    users = JSON.parse(@response.body)
    assert_equal 1, users.length
    assert_equal 980190962, users[0]["user_id"]
  end

end
