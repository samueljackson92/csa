require 'test_helper'

class CoffeeControllerTest < ActionController::TestCase

  test "test_serves_tea" do
    @request.headers["x-api-client-type"] = "application/coffee-pot-command"
    get :index
    assert_equal 418, @response.status
    assert_equal "I'm a teapot", @response.body
  end

end
