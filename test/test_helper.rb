ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# Include SimpleConv for converage
require 'simplecov'
SimpleCov.start

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
end
