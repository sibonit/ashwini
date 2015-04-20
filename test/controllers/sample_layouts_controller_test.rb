require 'test_helper'

class SampleLayoutsControllerTest < ActionController::TestCase
  test "should get 1column" do
    get :1column
    assert_response :success
  end

  test "should get 2column-even" do
    get :2column-even
    assert_response :success
  end

  test "should get 2column-uneven" do
    get :2column-uneven
    assert_response :success
  end

end
