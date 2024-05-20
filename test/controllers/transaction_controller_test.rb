require "test_helper"

class TransactionControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get transaction_index_url
    assert_response :success
  end

  test "should get linked" do
    get transaction_linked_url
    assert_response :success
  end
end
