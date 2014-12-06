require 'test_helper'

class BroadcastTest < ActiveSupport::TestCase

  fixtures :users
  fixtures :broadcasts

  setup do
    @broadcast = broadcasts(:one)
    @broadcast.user = users(:one)
  end

  test "should convert a broadcast to a string" do
    assert_equal "id: 980190962 content: Wibble, wibble, wibble, wibble, wibble yea! user: 980190962", @broadcast.to_s(),
                 "Broadcast text should be equal to the expected string."
  end

  test "should convert a broadcast without a user to a string" do
    @broadcast.user = nil

    assert_equal "id: 980190962 content: Wibble, wibble, wibble, wibble, wibble yea!", @broadcast.to_s(),
                 "Broadcast text should be equal to the expected string."
  end

  test "should return the number of broadcasts shown per page" do
    assert_equal 8, Broadcast.per_page, "Number of broadcasts per page does not match expected."
  end

  test "should return one broadcast from search" do
    result = Broadcast.where(Broadcast.search_conditions("wib", Broadcast.search_columns))

    assert_equal 1, result.length, "Size of returned query should be one"
    assert_equal 980190962, result[0].user_id, "User id of record should match expected"
  end

  test "should return no broadcasts from search" do
    result = Broadcast.where(Broadcast.search_conditions("Not A Broadcast", Broadcast.search_columns))
    assert_equal result.length, 0, "Size of returned query should be zero"
  end

  test "should return multiple users from search" do
    result = Broadcast.where(Broadcast.search_conditions("", ["content"]))
    assert_equal 2, result.length, "Size of returned query should be one"
  end

  test "should set searchable columns for all users" do
    Broadcast.searchable_by("content")
    assert Broadcast.search_columns == ["content"]
  end
end
