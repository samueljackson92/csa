require 'test_helper'

class BroadcastTest < ActiveSupport::TestCase

  setup do
    @broadcast = broadcasts(:one)
    @broadcast.user = users(:one)
  end

  test "should convert a broadcast to a string" do
    assert_equal "id: 980190962 content: This is my broadcast text user: 980190962", @broadcast.to_s(),
                 "Broadcast text should be equal to the expected string."
  end

  test "should convert a broadcast without a user to a string" do
    @broadcast.user = nil

    assert_equal "id: 980190962 content: This is my broadcast text", @broadcast.to_s(),
                 "Broadcast text should be equal to the expected string."
  end

  test "should return the number of broadcasts shown per page" do
    assert_equal 8, Broadcast.per_page, "Number of broadcasts per page does not match expected."
  end
end
