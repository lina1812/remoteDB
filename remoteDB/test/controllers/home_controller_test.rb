require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get shell" do
    get :shell
    assert_response :success
  end

  test "should get text" do
    get :text
    assert_response :success
  end

  test "should get user_control" do
    get :user_control
    assert_response :success
  end

end
