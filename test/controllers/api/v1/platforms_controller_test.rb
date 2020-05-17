# frozen_string_literal: true

require 'test_helper'

class Api::V1::PlatformsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @platform = platforms(:youtube)
  end

  test 'should get index' do
    get api_v1_platforms_url, as: :json
    assert_response :success
  end

  test 'should create platform' do
    assert_difference('Platform.count') do
      post api_v1_platforms_url,
           params: { platform: { platform: 'bilibili' } }, as: :json
    end

    assert_response 201
  end

  test 'should show platform' do
    get api_v1_platform_url(@platform), as: :json
    assert_response :success
  end

  test 'should update platform' do
    patch api_v1_platform_url(@platform),
          params: { platform: { platform: 'bilibili' } }, as: :json
    assert_response 200
  end

  test 'should destroy platform' do
    assert_raise(StandardError) do
      delete api_v1_platform_url(@platform), as: :json
    end
  end
end
