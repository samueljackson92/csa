require 'test_helper'
require 'broadcasts_helper'

class BroadcastsHelperTest < ActionView::TestCase

  fixtures :broadcasts

  setup do
    @broadcast = broadcasts(:one)
  end

  test "should display all feeds" do
    feed_list = display_feeds(@broadcast)
    assert_equal 'Twitter, Rss', feed_list, "String of feeds should match the expected"
  end
end
