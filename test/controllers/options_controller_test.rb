require "test_helper"

class OptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @option = options(:one)
  end

  test "should get index" do
    get options_url, as: :json
    assert_response :success
  end

  test "should create option" do
    assert_difference('Option.count') do
      post options_url, params: { option: { body: @option.body, description: @option.description, poll_id: @option.poll_id } }, as: :json
    end

    assert_response 201
  end

  test "should show option" do
    get option_url(@option), as: :json
    assert_response :success
  end

  test "should update option" do
    patch option_url(@option), params: { option: { body: @option.body, description: @option.description, poll_id: @option.poll_id } }, as: :json
    assert_response 200
  end

  test "should destroy option" do
    assert_difference('Option.count', -1) do
      delete option_url(@option), as: :json
    end

    assert_response 204
  end
end
