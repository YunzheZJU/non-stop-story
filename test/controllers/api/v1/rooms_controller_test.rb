# frozen_string_literal: true

require 'test_helper'

class Api::V1::RoomsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @room = rooms(:test_1)
  end

  test 'should get index' do
    get api_v1_rooms_url, as: :json
    assert_response :success
  end

  test 'should create room' do
    assert_difference('Room.count') do
      post api_v1_rooms_url,
           params: { room: { room: 'NewRoom',
                             platform: platforms(:youtube)[:id] } },
           as: :json
    end

    assert_response 201
  end

  test 'should show room' do
    get api_v1_room_url(@room), as: :json
    assert_response :success
  end

  test 'should update room' do
    patch api_v1_room_url(@room),
          params: { room: { room: 'NewRoom',
                            platform: platforms(:youtube)[:id] } },
          as: :json
    assert_response 200
  end

  test 'should destroy room' do
    assert_raise(StandardError) do
      delete api_v1_room_url(@room), as: :json
    end
  end
end
