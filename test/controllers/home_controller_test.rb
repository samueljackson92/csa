require 'test_helper'

class HomeControllerTest < ActionController::TestCase

  test "should get home index" do
    get :index
    assert_response :success
  end

end
