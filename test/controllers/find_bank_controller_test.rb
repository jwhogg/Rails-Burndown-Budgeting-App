require "test_helper"

class FindBankControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get find_bank_index_url
    assert_response :success
  end

  test "should get activate_bank" do
    get find_bank_activate_bank_url
    assert_response :success
  end
end
