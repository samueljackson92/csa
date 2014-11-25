require 'test_helper'

class UserTest < ActiveSupport::TestCase

  fixtures :users

  test "invalid with empty attributes" do
    user = User.new
    assert !user.valid? # Check to see if user.errors is not empty
    assert user.errors[:firstname].any?
    assert user.errors[:surname].any?
    assert user.errors[:grad_year].any?
    assert user.errors[:email].any?
  end

  test "grad_year date range between 1970 and this year" do
    user = User.new(:firstname => "Chris",
                    :surname => "Loftus",
                    :email => "cwl1@aber.ac.uk")
    # Do boundary checks
    user.grad_year = 1969
    assert !user.valid?
    # We could check the error message here as follows but I think this is
    # too volatile to test and also will vary (eventually) depending on locale
    # assert_equal "expected error message", user.errors.on(:grad_year)

    user.grad_year = 1970
    assert user.valid?

    user.grad_year = Time.now.year.to_i + 1
    assert !user.valid?

    user.grad_year = Time.now.year.to_i
    assert user.valid?
  end

  # Try writing some tests to check that the email is formatted correctly

  test "unique email" do
    user = User.new(firstname: "Chris",
                    surname: "Loftus",
                    grad_year: 1985,
                    email: users(:one).email)
    assert !user.valid?, 'User\'s email should be valid.'
  end

  test "should return one user from search" do
    result = User.where(User.search_conditions("lof", User.search_columns))

    assert_equal 1, result.length, "Size of returned query should be one"
    assert_equal 'Loftus', result[0].surname, "Surname of record should match expected"
  end

  test "should return no users from search" do
    result = User.where(User.search_conditions("UnknownUser", User.search_columns))

    assert_equal result.length, 0, "Size of returned query should be one"
  end

  test "should return multiple users from search" do
    result = User.where(User.search_conditions("Chris", ["firstname"]))

    assert_equal 2, result.length, "Size of returned query should be one"

    user1 = result[0]
    user2 = result[1]

    assert_equal 'Ashton', user1.surname, "Surname of first user should match expected."
    assert_equal 'Loftus', user2.surname, "Surname of second user should match expected."
  end

  test "should set searchable columns for all users" do
    User.searchable_by("firstname", "surname")
    assert User.search_columns == ["firstname", "surname"]
  end

  test "should return number of users per page" do
      assert_equal User.per_page, 6, "Number of users per page should match"
  end
end
