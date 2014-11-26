require 'test_helper'

class UserDetailsTest < ActiveSupport::TestCase

  fixtures :user_details

  setup do
    @user_detail = user_details(:one)
  end

  test "should set the password" do
    @user_detail.password = "mypassword"
    assert_equal "mypassword", @user_detail.password
  end

  test "should generate encrypted password on save" do
    @user_detail.password = "mypassword"
    assert_equal "mypassword", @user_detail.password
    @user_detail.save
    assert_equal 64, @user_detail.crypted_password.length
  end

  test "should not set the password when password is blank" do
    @user_detail.password = ""
    assert_not_equal "mypassword", @user_detail.password
  end

  test "should authenticate using a users login details" do
    user_detail = UserDetail.authenticate("admin", "taliesin")
    assert_not_nil user_detail, "Authentication failed"

    assert_equal 980190962, user_detail.id, "ID should match expected"
      "id should match expected"

    assert_equal 980190962, user_detail.user_id, "ID should match expected"
      "user id should match expected"

    assert_equal "admin", user_detail.login, "Login name should match expected"
      "login should match expected"

    assert_equal "ced6c1da3e5436a7816d428910172927e0ac0fbaeb0b7454fb0a0372dceb3502", user_detail.crypted_password,
      "crypted password should match expected"

    assert_equal "21613652800.8890977334258171", user_detail.salt
      "salt should match expected"
  end

  test "should not authenticate an unknown user" do
    user_detail = UserDetail.authenticate("not_a_user", "not_a_password")
    assert_nil user_detail, "User details should not be returned for a user that doesn't exist"
  end

  test "should not authenticate an invalid password" do
    user_detail = UserDetail.authenticate("admin", "not_a_password")
    assert_nil user_detail, "User details should not be returned for a valid user with invalid password"
  end

end
