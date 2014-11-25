# Include SimpleConv for converage
require 'simplecov'
SimpleCov.start do
    add_filter '/spec/'
    add_filter '/config/'
    add_filter '/lib/'
    add_filter '/vendor/'

    add_group 'Controllers', 'app/controllers'
    add_group 'Models', 'app/models'
    add_group 'Helpers', 'app/helpers'
    add_group 'Mailers', 'app/mailers'
    add_group 'Views', 'app/views'
end

ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def create_dummy_session(id)
      @user_detail = user_details(id)
      session[:user_id] = @user_detail.id
  end

  def destroy_dummy_session()
      session[:user_id] = nil
  end

  def create_timestampped_broadcast(msg)
    time = Time.now.getutc
    user = users(:one)
    Broadcast.new({user: user, content: msg + time.to_s})
  end

  def create_large_tweet()
    "Bacon ipsum dolor amet porchetta bacon short loin pork loin kielbasa shoulder drumstick. Short ribs filet mignon ham ball tip strip steak, ribeye"
  end
end
