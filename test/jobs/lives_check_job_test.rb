# frozen_string_literal: true

require 'json'
require 'test_helper'
require 'utils/network'
require 'utils/transform'

# rubocop:todo Metrics/ClassLength
class LivesCheckJobTest < ActiveJob::TestCase
  include ActiveJob::TestHelper

  test 'should update live' do
    live_one = lives(:test_1)
    live_two = lives(:test_2)
    live_three = lives(:test_3)
    live_five = lives(:test_5)
    live_info_one = { 'status' => 'living', 'watching' => 1000, 'like' => 2000 }
    live_info_two = { 'status' => 'living', 'watching' => 1000 }
    live_info_three = { 'status' => 'living', 'like' => 2000 }
    live_info_five = { 'status' => 'living' }

    assert_difference('Hotness.count', 3) do
      LivesCheckJob.update_live live_one, live_info_one
      LivesCheckJob.update_live live_two, live_info_two
      LivesCheckJob.update_live live_three, live_info_three
      LivesCheckJob.update_live live_five, live_info_five
    end

    assert(%i[test_1 test_2 test_3 test_5].all? { |label| lives(label).duration.nil? })
    assert_in_delta Time.zone.parse('2020-03-27 0:00:00'),
                    lives(:test_1).start_at, 2
    assert_in_delta Time.zone.parse('2020-03-27 0:00:00'),
                    lives(:test_2).start_at, 2
    assert_in_delta Time.zone.parse('2020-03-27 0:05:00'),
                    lives(:test_3).start_at, 2
    assert_in_delta Time.zone.parse('2120-03-27 0:00:00'),
                    lives(:test_5).start_at, 2
  end

  test 'should close live' do
    live_one = lives(:test_1)
    live_two = lives(:test_2)
    live_three = lives(:test_3)
    live_four = lives(:test_4)
    live_five = lives(:test_5)
    live_six = lives(:test_6)
    assert_difference('Room.open(channels(:test_1)).count', -4) do
      LivesCheckJob.close_live live_one
      LivesCheckJob.close_live live_two
      LivesCheckJob.close_live live_three
      LivesCheckJob.close_live live_four
      LivesCheckJob.close_live live_five
      LivesCheckJob.close_live live_six
    end

    assert_not_nil lives(:test_1).duration
    assert_equal 1500, lives(:test_2).duration
    assert_equal 1500, lives(:test_3).duration
    assert_not_nil lives(:test_4).duration
    assert_raise(StandardError) { lives(:test_5).reload }
    assert_raise(StandardError) { rooms(:test_5) }
    assert_raise(StandardError) { lives(:test_6).reload }
    assert_raise(StandardError) { rooms(:test_6) }
  end

  test 'should handle start at time' do
    live = lives(:test_5)
    live_info = { 'status' => 'living',
                  'title' => 'NewTitle', 'cover' => 'NewCover',
                  'watching' => 1000, 'like' => 2000, }
    travel_to Time.zone.parse('2120-03-27 0:00:05') do
      LivesCheckJob.sync_live live, live_info
    end

    assert_equal 'TestLive5', lives(:test_5).title
    assert_equal 'TestCover5', lives(:test_5).cover
    assert_nil lives(:test_5).duration
    assert_in_delta Time.zone.parse('2120-03-27 0:00:00'),
                    lives(:test_5).start_at, 2
  end

  test 'should handle overslept schedule' do
    live = lives(:test_1)
    live_info = { 'title' => 'TestLive1', 'cover' => 'TestCover1',
                  'status' => 'scheduled', }

    LivesCheckJob.sync_live live, live_info

    assert_equal 'TestLive1', lives(:test_1).title
    assert_nil lives(:test_1).cover
    assert_nil lives(:test_1).duration
    assert_in_delta Time.zone.parse('2020-03-27 00:00:00'),
                    lives(:test_1).start_at,
                    2
  end

  test 'should handle cancelled schedule' do
    live = lives(:test_5)
    live_info = { 'status' => 'error', 'err' => 'Not Found' }

    LivesCheckJob.sync_live live, live_info

    assert lives(:test_5).frozen?
    assert_raise(StandardError) { rooms(:test_5) }
  end

  test 'should handle sudden end' do
    live = lives(:test_1)
    live_info = { 'title' => 'TestLive1', 'cover' => 'TestCover1',
                  'status' => 'ended', }

    LivesCheckJob.sync_live live, live_info

    assert_equal 'TestLive1', lives(:test_1).title
    assert_nil lives(:test_1).cover
    assert_not_nil lives(:test_1).duration
    assert_in_delta Time.zone.parse('2020-03-27 00:00:00'),
                    lives(:test_1).start_at, 2
  end

  test 'should handle restart' do
    live = lives(:test_2)
    live_info = { 'status' => 'living',
                  'title' => 'NewTitle', 'cover' => 'NewCover',
                  'watching' => 1000, 'like' => 2000, }

    LivesCheckJob.sync_live live, live_info

    assert_equal 'TestLive2', lives(:test_2).title
    assert_nil lives(:test_2).cover
    assert_nil lives(:test_2).duration
    assert_in_delta Time.zone.parse('2020-03-27 00:00:00'),
                    lives(:test_2).start_at, 2
  end

  test 'should handle sudden private' do
    live = lives(:test_1)
    live_info = { 'status' => 'error', 'err' => 'Not Found' }

    LivesCheckJob.sync_live live, live_info

    assert_not_nil lives(:test_1).duration
  end

  test 'should handle private after end' do
    live = lives(:test_2)
    live_info = { 'status' => 'error', 'err' => 'Not Found' }

    LivesCheckJob.sync_live live, live_info

    assert_equal 1500, lives(:test_2).duration
  end
end

# rubocop:enable Metrics/ClassLength
