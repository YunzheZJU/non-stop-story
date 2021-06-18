# frozen_string_literal: true

require 'test_helper'

class Api::V1::HotnessesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hotness = hotnesses(:test_1)
  end

  test 'should get index' do
    assert_raise(StandardError) do
      get api_v1_hotnesses_url
    end
  end

  test 'should get index filter' do
    get api_v1_hotnesses_url, params: { lives: [] }
    assert_response :success
    assert_equal 0, JSON.parse(@response.body)['total']

    get api_v1_hotnesses_url, params: { lives: [lives(:test_2).id] }
    assert_response :success
    assert_equal 2, JSON.parse(@response.body)['total']

    get api_v1_hotnesses_url, params: { lives: [lives(:test_1).id, lives(:test_2).id, lives(:test_3).id] }
    assert_response :success
    assert_equal 3, JSON.parse(@response.body)['total']
  end

  test 'should create hotness' do
    assert_difference('Hotness.count') do
      post api_v1_hotnesses_url,
           params: { hotness: { watching: 100,
                                like: 200,
                                live: lives(:test_1).id, } },
           as: :json
    end

    assert_response 201
  end

  test 'should show hotness' do
    get api_v1_hotness_url(@hotness)
    assert_response :success
  end

  test 'should update hotness' do
    patch api_v1_hotness_url(@hotness),
          params: { hotness: { watching: 100,
                               like: nil,
                               live: lives(:test_2).id, } },
          as: :json
    assert_response 200
  end

  test 'should destroy hotness' do
    delete api_v1_hotness_url(@hotness)
    assert_response :success
  end
end
