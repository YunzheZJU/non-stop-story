# frozen_string_literal: true

require 'test_helper'

class Api::V1::ChannelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @channel = channels(:test_1)
  end

  test 'should get index' do
    get api_v1_channels_url, as: :json
    assert_response :success
  end

  test 'should get index filter platforms' do
    get api_v1_channels_url, params: {
      platforms: platforms(:youtube)[:id]
    }
    data = JSON.parse(@response.body)
    assert_response :success
    assert_equal 3, data['total']
  end

  test 'should get index filter members' do
    get api_v1_channels_url, params: {
      members: [members(:test_1)[:id], members(:test_2)[:id]]
    }
    data = JSON.parse(@response.body)
    assert_response :success
    assert_equal 4, data['total']
  end

  test 'should get index pagination' do
    get api_v1_channels_url, params: {
      page: 2,
      limit: 2
    }
    data = JSON.parse(@response.body)
    assert_equal 2, data['channels'].size
    assert_equal 4, data['total']
  end

  test 'should get index filter pagination' do
    get api_v1_channels_url, params: {
      platforms: platforms(:youtube)[:id],
      members: members(:test_2)[:id],
      page: 2,
      limit: 1
    }
    data = JSON.parse(@response.body)
    assert_equal 1, data['channels'].size
    assert_equal 2, data['total']
  end

  test 'should create channel' do
    assert_difference('Channel.count') do
      post api_v1_channels_url,
           params: { channel: { channel: 'UC123456',
                                platform: platforms(:youtube)[:id],
                                member: members(:test_1)[:id] } },
           as: :json
    end

    assert_response 201
  end

  test 'should show channel' do
    get api_v1_channel_url(@channel), as: :json
    assert_response :success
  end

  test 'should update channel' do
    patch api_v1_channel_url(@channel),
          params: { channel: { channel: '123456',
                               platform: platforms(:bilibili)[:id] } },
          as: :json
    assert_response 200
  end

  test 'should destroy channel' do
    assert_raise(StandardError) do
      delete api_v1_channel_url(@channel), as: :json
    end
  end
end
