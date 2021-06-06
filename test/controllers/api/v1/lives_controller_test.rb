# frozen_string_literal: true

require 'test_helper'

# rubocop:todo Metrics/ClassLength
class Api::V1::LivesControllerTest < ActionDispatch::IntegrationTest
  test 'should index' do
    get api_v1_lives_url

    assert_response :success
  end

  test 'should show' do
    get api_v1_live_url lives :test_1

    assert_response :success
    assert_equal 'TestLive1', JSON.parse(@response.body)['title']
  end

  test 'should update' do
    patch api_v1_live_url(lives(:test_1)), params: {
      live: { title: 'NewLiveTitle',
              start_at: Time.current.iso8601,
              room: rooms(:test_2)[:id],
              ignored_param: 'any', },
    }
    lives(:test_1).reload
    assert_response :success
    assert_equal 'NewLiveTitle', lives(:test_1).title
    assert_equal rooms(:test_2), lives(:test_1).room
    assert_equal channels(:test_1), lives(:test_1).channel
    assert_nil lives(:test_1).duration
    assert_nil lives(:test_1).video
    assert_in_delta Time.current, lives(:test_1).start_at, 2

    assert_raise(StandardError) do
      patch api_v1_live_url(lives(:test_1)),
            params: { live: { start_at: 'InvalidTimeType' } }
    end
  end

  test 'should destroy' do
    assert_raise(StandardError) do
      delete api_v1_member_url(lives(:test_1))
    end

    delete api_v1_live_url lives :test_4

    assert_response :success
    assert_raise(StandardError) { lives(:test_4).reload }
  end

  test 'should create' do
    post api_v1_lives_url, params: {
      live: { title: 'NewLive',
              start_at: Time.current.iso8601,
              channel: channels(:test_1)[:id],
              room: rooms(:test_1)[:id],
              duration: 500,
              video: videos(:test_1)[:id],
              ignored_param: 'any', },
    }
    assert_response :success
    assert_not_nil Live.find_by_title 'NewLive'
  end

  test 'should get ended' do
    get '/api/v1/lives/ended'
    assert_response :success
    JSON.parse(@response.body)['lives'].each do |live|
      assert_includes %w[TestLive2 TestLive3 TestLive7], live['title']
    end
  end

  test 'should get ended pagination' do
    get '/api/v1/lives/ended', params: {
      page: 1, limit: 1,
    }
    assert_response :success
    assert_equal 1, JSON.parse(@response.body)['lives'].size
    assert_equal 3, JSON.parse(@response.body)['total']
    JSON.parse(@response.body)['lives'].each do |live|
      assert_includes %w[TestLive2 TestLive3 TestLive7], live['title']
    end

    get '/api/v1/lives/ended', params: {
      page: 2, limit: 1,
    }
    assert_response :success
    assert_equal 1, JSON.parse(@response.body)['lives'].size
    assert_equal 3, JSON.parse(@response.body)['total']
    JSON.parse(@response.body)['lives'].each do |live|
      assert_includes %w[TestLive2 TestLive3 TestLive7], live['title']
    end
  end

  test 'should get ended filter channel' do
    get '/api/v1/lives/ended', params: {
      channels: channels(:test_1)[:id],
    }
    assert_response :success
    JSON.parse(@response.body)['lives'].each do |live|
      assert_includes %w[TestLive2 TestLive3], live['title']
    end

    get '/api/v1/lives/ended?channels=1'
    assert_response :success
    assert_equal 0, JSON.parse(@response.body)['lives'].size
  end

  test 'should get ended filter start_after' do
    get '/api/v1/lives/ended', params: {
      start_after: Time.zone.parse('2020-03-27 0:03:00').to_i,
    }
    assert_response :success
    JSON.parse(@response.body)['lives'].each do |live|
      assert_includes %w[TestLive3 TestLive7], live['title']
    end
  end

  test 'should get ended filter start_before' do
    get '/api/v1/lives/ended', params: {
      start_before: Time.zone.parse('2020-03-27 0:03:00').to_i,
    }
    assert_response :success
    JSON.parse(@response.body)['lives'].each do |live|
      assert_includes %w[TestLive2], live['title']
    end
  end

  test 'should get current' do
    get '/api/v1/lives/current'
    assert_response :success
    JSON.parse(@response.body)['lives'].each do |live|
      assert_includes %w[TestLive1 TestLive4], live['title']
    end
  end

  test 'should get current should filter channel' do
    get '/api/v1/lives/current', params: {
      channels: channels(:test_1)[:id],
    }
    assert_response :success
    JSON.parse(@response.body)['lives'].each do |live|
      assert_includes %w[TestLive1 TestLive4], live['title']
    end

    get '/api/v1/lives/current?channels=1'
    assert_response :success
    assert_equal 0, JSON.parse(@response.body)['lives'].size
  end

  test 'should get scheduled' do
    get '/api/v1/lives/scheduled'
    assert_response :success
    JSON.parse(@response.body)['lives'].each do |live|
      assert_includes %w[TestLive5 TestLive6], live['title']
    end
  end

  test 'should get scheduled filter channels' do
    get '/api/v1/lives/scheduled', params: {
      channels: channels(:test_1)[:id],
    }
    assert_response :success
    JSON.parse(@response.body)['lives'].each do |live|
      assert_includes %w[TestLive5 TestLive6], live['title']
    end

    get '/api/v1/lives/scheduled', params: {
      channels: 100,
    }
    assert_response :success
    assert_equal 0, JSON.parse(@response.body)['lives'].size
  end

  test 'should get scheduled filter start_before' do
    get '/api/v1/lives/scheduled', params: {
      start_before: 7.days.from_now.to_i,
    }
    assert_response :success
    assert_equal 0, JSON.parse(@response.body)['lives'].size
  end
end

# rubocop:enable Metrics/ClassLength
