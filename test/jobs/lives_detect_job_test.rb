# frozen_string_literal: true

require 'json'
require 'test_helper'
require 'utils/network'
require 'utils/transform'

# rubocop:todo Metrics/ClassLength
class LivesDetectJobTest < ActiveJob::TestCase
  include ActiveJob::TestHelper

  # rubocop:todo Metrics/BlockLength

  test 'should create new lives' do
    channel = channels(:test_1)
    live_infos = {
      'NewRoom' => { 'title' => 'NewLiveTitle1', 'cover' => 'NewCover1' },
      'ScheduledRoom' => {
        'title' => 'NewLiveTitle2',
        'startAt' => 1.day.from_now.to_i,
      },
    }

    room_vals = live_infos.keys
    open_room_vals = Room.open(channel).pluck('room')

    assert_difference('Room.open(channel).count', 2) do
      LivesDetectJob.create_new_lives(
        live_infos.select { |room| (room_vals - open_room_vals).include? room },
        channel
      )
    end

    assert_not_nil Room.find_by_room('NewRoom')
    assert_not_nil Live.find_by_title('NewLiveTitle1')
    assert_not_nil Live.find_by_cover('NewCover1')
    assert_in_delta(
      Time.current,
      Live.find_by_title('NewLiveTitle1').start_at,
      2
    )
    assert_not_nil Room.find_by_room('ScheduledRoom')
    assert_not_nil Live.find_by_title('NewLiveTitle2')
    assert_in_delta(
      1.day.from_now,
      Live.find_by_title('NewLiveTitle2').start_at,
      2
    )
  end

  test 'should update lives' do
    channel = channels(:test_1)
    live_infos = {
      'TestRoom4' => { 'title' => 'UpdatedLiveTitle1', 'cover' => 'NewCover1' },
      'TestRoom5' => {
        'title' => 'UpdatedLiveTitle2',
        'startAt' => 1.day.from_now.to_i,
      },
      'TestRoom6' => { 'title' => 'StartedScheduledTitle' },
    }

    room_vals = live_infos.to_a.map { |room, _live_info| room }
    open_room_vals = Room.open(channel).pluck('room')

    assert_difference('Room.open(channel).count', 0) do
      LivesDetectJob.update_lives(
        live_infos.select { |room| (open_room_vals & room_vals).include? room }
      )
    end

    assert_nil lives(:test_4).duration
    assert_equal 'UpdatedLiveTitle1', lives(:test_4).title
    assert_equal 'NewCover1', lives(:test_4).cover
    assert_nil lives(:test_5).duration
    assert_equal 'UpdatedLiveTitle2', lives(:test_5).title
    assert_in_delta 1.day.from_now, lives(:test_5).start_at, 2
    assert_nil lives(:test_5).cover
    assert_nil lives(:test_6).duration
    assert_equal 'StartedScheduledTitle', lives(:test_6).title
    assert_in_delta Time.current, lives(:test_6).start_at, 2
  end

  test 'should sync lives' do
    channel = channels(:test_1)
    live_infos = {
      'TestRoom4' => { 'title' => 'UpdatedLiveTitle1' },
      'TestRoom5' => {
        'title' => 'UpdatedLiveTitle2',
        'startAt' => 1.day.from_now.to_i,
      },
      'TestRoom6' => { 'title' => 'StartedScheduledTitle' },
      'NewRoom' => { 'title' => 'NewLiveTitle1' },
      'ScheduledRoom' => {
        'title' => 'NewLiveTitle2',
        'startAt' => 1.day.from_now.to_i,
      },
    }

    assert_difference('Room.open(channel).count', 2) do
      LivesDetectJob.sync_live_rooms channel, live_infos
    end

    assert_nil lives(:test_1).duration
    assert_nil lives(:test_4).duration
    assert_equal 'UpdatedLiveTitle1', lives(:test_4).title
    assert_in_delta Time.zone.parse('2020-03-27 0:00:00'),
                    lives(:test_4).start_at,
                    2
    assert_nil lives(:test_5).duration
    assert_equal 'UpdatedLiveTitle2', lives(:test_5).title
    assert_in_delta 1.day.from_now, lives(:test_5).start_at, 2
    assert_nil lives(:test_6).duration
    assert_equal 'StartedScheduledTitle', lives(:test_6).title
    assert_in_delta Time.current, lives(:test_6).start_at, 2
    assert_not_nil Room.find_by_room('NewRoom')
    assert_not_nil Live.find_by_title('NewLiveTitle1')
    assert_in_delta(
      Time.current,
      Live.find_by_title('NewLiveTitle1').start_at,
      2
    )
    assert_not_nil Room.find_by_room('ScheduledRoom')
    assert_not_nil Live.find_by_title('NewLiveTitle2')
    assert_in_delta(
      1.day.from_now,
      Live.find_by_title('NewLiveTitle2').start_at,
      2
    )
  end
  # rubocop:enable Metrics/BlockLength
end

# rubocop:enable Metrics/ClassLength
