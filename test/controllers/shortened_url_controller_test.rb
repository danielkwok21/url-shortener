require 'test_helper'

class ShortenedUrlControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get shortened_url_create_url
    assert_response :success
  end

  test "should get list" do
    get shortened_url_list_url
    assert_response :success
  end

  test "should get get" do
    get shortened_url_get_url
    assert_response :success
  end

end
