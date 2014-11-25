require 'test_helper'

class BroadcastTest < ActiveSupport::TestCase

  fixtures :broadcasts

  setup do
    @broadcast_message = "#CraigBakes all the cucumbers at "
  end

  test "send broadcast to all feeds" do
    feeds = {alumni_email: "slj11@aber.ac.uk", "twitter" => true, "atom" => true, "Rss" => true, "facebook"=> true, "email" => true}
    result = BroadcastService.broadcast(create_timestampped_broadcast(@broadcast_message), feeds)
    assert_equal 0, result.length, "There should be no failed broadcasts"
  end

  test "send broadcast to just email" do
    feeds = {"email" => true}
    result = BroadcastService.broadcast(create_timestampped_broadcast(@broadcast_message), feeds)
    assert_equal 0, result.length, "The broadcast should fail"
  end

  test "send broadcast to just email that fails" do
    feeds = {alumni_email: "slj11@aber.ac.uk", "email" => true}
    result = BroadcastService.broadcast('', feeds)

    assert_equal 1, result.length, "The broadcast should fail"
    assert_equal "slj11@aber.ac.uk", result[0][:feed], "The failed broadcast feed should be twitter"
    assert_equal "500", result[0][:code], "The failed broadcast code does not match"
  end

  test "send broadcast to just twitter" do
    feeds = {"twitter" => true}
    result = BroadcastService.broadcast(create_timestampped_broadcast(@broadcast_message), feeds)
    assert_equal 0, result.length, "The broadcast should not fail"
  end

  test "send broadcast to twitter that fails" do
    feeds = {"twitter" => true}
    result = BroadcastService.broadcast('', feeds)

    assert_equal 1, result.length, "The broadcast should fail"
    assert_equal "twitter", result[0][:feed], "The failed broadcast feed should be twitter"
    assert_equal "500", result[0][:code], "The failed broadcast code does not match"
  end

  test "send broadcast to twitter throws" do
    # Sending the same message twice causes twitter to throw an exception.
    feeds = {"twitter" => true}
    message = create_timestampped_broadcast(@broadcast_message)

    result = BroadcastService.broadcast(message, feeds)
    assert_equal 0, result.length, "The broadcast should not fail"

    result = BroadcastService.broadcast(message, feeds)
    assert_equal 1, result.length, "The broadcast should fail on duplicate message"
    assert_equal "twitter", result[0][:feed], "The failed broadcast feed should be twitter"
    assert_equal "403", result[0][:code], "The failed broadcast code does not match"
  end


end
