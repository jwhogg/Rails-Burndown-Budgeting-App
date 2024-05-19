require "test_helper"

class HomeControlerControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get home_controler_index_url
    assert_response :success
  end
end
