require 'test_helper'

class CollectedEmailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @collected_email = collected_emails(:one)
  end

  test "should get index" do
    get collected_emails_url
    assert_response :success
  end

  test "should get new" do
    get new_collected_email_url
    assert_response :success
  end

  test "should create collected_email" do
    assert_difference('CollectedEmail.count') do
      post collected_emails_url, params: { collected_email: { email: @collected_email.email, shop_id: @collected_email.shop_id } }
    end

    assert_redirected_to collected_email_url(CollectedEmail.last)
  end

  test "should show collected_email" do
    get collected_email_url(@collected_email)
    assert_response :success
  end

  test "should get edit" do
    get edit_collected_email_url(@collected_email)
    assert_response :success
  end

  test "should update collected_email" do
    patch collected_email_url(@collected_email), params: { collected_email: { email: @collected_email.email, shop_id: @collected_email.shop_id } }
    assert_redirected_to collected_email_url(@collected_email)
  end

  test "should destroy collected_email" do
    assert_difference('CollectedEmail.count', -1) do
      delete collected_email_url(@collected_email)
    end

    assert_redirected_to collected_emails_url
  end
end
