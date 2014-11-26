require 'test_helper'

class UsersHelperTest < ActionView::TestCase
  fixtures :users
  fixtures :images

  setup do
    @user_with_image = users(:one)
    @user_without_image = users(:two)
  end
  test "generate default image for user without profile image" do
    default_img_tag = "<img alt=\"No photo available\" border=\"0\" src=\"/images/blank-cover_medium.png\" title=\"No photo available\" />"

    @user_without_image = users(:two)
    image_tag = image_for(@user_without_image)

    assert_equal default_img_tag, image_tag, "Generated default image tag should match expected"
  end

  test "generate profile image for user" do
    expected_img_tag = "<a href=\"/system/images/photos/000/000/001/original/DSC_0408.JPG?1378372324\"><img alt=\"Image of Chris Loftus\" border=\"0\" class=\"image-tag\" src=\"/system/images/photos/000/000/001/medium/DSC_0408.JPG?1378372324\" title=\"Image of Chris Loftus\" /></a>"
    image_tag = image_for(@user_with_image)
    assert_equal expected_img_tag, image_tag, "Generated image tag should match expected"
  end

  test "generate diffrent size profile image for user" do
    expected_img_tag = "<a href=\"/system/images/photos/000/000/001/original/DSC_0408.JPG?1378372324\"><img alt=\"Image of Chris Loftus\" border=\"0\" class=\"image-tag\" src=\"/system/images/photos/000/000/001/small/DSC_0408.JPG?1378372324\" title=\"Image of Chris Loftus\" /></a>"
    image_tag = image_for(@user_with_image, :small)
    assert_equal expected_img_tag, image_tag, "Generated image tag should match expected"
  end

  test "generate default remote image for user without profile image" do
    default_remote_img_tag = "<a class=\"image-tag\" data-method=\"get\" data-remote=\"true\" href=\"/users/298486374?page=1\"><img alt=\"No photo available\" border=\"0\" src=\"/images/blank-cover_medium.png\" title=\"No photo available\" /></a>"
    remote_image_tag = remote_image_for(@user_without_image, 1)
    assert_equal default_remote_img_tag, remote_image_tag, "Generated default image tag should match expected"
  end

  test "generate remote image for user" do
    expected_remote_img_tag = "<a class=\"image-tag\" data-method=\"get\" data-remote=\"true\" href=\"/users/298486374?page=1\"><img alt=\"No photo available\" border=\"0\" src=\"/images/blank-cover_medium.png\" title=\"No photo available\" /></a>"
    remote_image_tag = remote_image_for(@user_without_image, 1)
    assert_equal expected_remote_img_tag, remote_image_tag, "Generated image tag should match expected"
  end

  test "generate different size remote image for user" do
    expected_remote_img_tag = "<a class=\"image-tag\" data-method=\"get\" data-remote=\"true\" href=\"/users/298486374?page=1\"><img alt=\"No photo available\" border=\"0\" src=\"/images/blank-cover_small.png\" title=\"No photo available\" /></a>"
    remote_image_tag = remote_image_for(@user_without_image, 1, :small)
    assert_equal expected_remote_img_tag, remote_image_tag, "Generated image tag should match expected"
  end

end
