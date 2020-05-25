# frozen_string_literal: true

require 'json'
require 'test_helper'
require 'utils/network'
require 'utils/transform'

# rubocop:todo Metrics/ClassLength
class LivesDetectJobTest < ActiveJob::TestCase
  include ActiveJob::TestHelper

  test 'live detecting job scheduling' do
    LivesDetectJob.set(wait: 5.seconds).perform_later
    assert_enqueued_with(job: LivesDetectJob)
    assert_enqueued_jobs(1)
  end

  test 'should close or destroy lives' do
    channel = channels(:test_1)
    live_infos = {}

    room_vals = live_infos.to_a.map { |room, _live_info| room }
    open_room_vals = Room.open(channel).pluck('room')

    assert_equal 4, open_room_vals.size

    LivesDetectJob.close_or_delete_lives open_room_vals - room_vals

    assert_equal 0, Room.open(channel).reload.size

    assert_not_nil lives(:test_1).duration
    assert_not_nil lives(:test_4).duration
    assert_raise(StandardError) { lives(:test_5) }
    assert_raise(StandardError) { rooms(:test_5) }
    assert_raise(StandardError) { lives(:test_6) }
    assert_raise(StandardError) { rooms(:test_6) }
  end

  test 'should create lives' do # rubocop:todo Metrics/BlockLength
    channel = channels(:test_1)
    live_infos = {
      'NewRoom' => { 'title' => 'NewLiveTitle1' },
      'ScheduledRoom' => {
        'title' => 'NewLiveTitle2',
        'startAt' => (Time.now + 1.day).to_i
      }
    }

    room_vals = live_infos.to_a.map { |room, _live_info| room }
    open_room_vals = Room.open(channel).pluck('room')

    assert_equal 4, open_room_vals.size

    LivesDetectJob.create_lives(
      live_infos.select { |room| (room_vals - open_room_vals).include? room },
      channel
    )

    assert_equal 6, Room.open(channel).reload.size

    assert_not_nil Room.find_by_room('NewRoom')
    assert_not_nil Live.find_by_title('NewLiveTitle1')
    assert_in_delta(
      Time.now,
      Live.find_by_title('NewLiveTitle1').start_at,
      2
    )
    assert_not_nil Room.find_by_room('ScheduledRoom')
    assert_not_nil Live.find_by_title('NewLiveTitle2')
    assert_in_delta(
      Time.now + 1.day,
      Live.find_by_title('NewLiveTitle2').start_at,
      2
    )
  end

  test 'should update lives' do
    channel = channels(:test_1)
    live_infos = {
      'TestRoom4' => { 'title' => 'UpdatedLiveTitle1' },
      'TestRoom5' => {
        'title' => 'UpdatedLiveTitle2',
        'startAt' => (Time.now + 1.day).to_i
      },
      'TestRoom6' => { 'title' => 'StartedScheduledTitle' }
    }

    room_vals = live_infos.to_a.map { |room, _live_info| room }
    open_room_vals = Room.open(channel).pluck('room')

    assert_equal 4, Room.open(channel).size

    LivesDetectJob.update_lives(
      live_infos.select { |room| (open_room_vals & room_vals).include? room }
    )

    assert_equal 4, Room.open(channel).reload.size
    assert_nil lives(:test_4).duration
    assert_equal 'UpdatedLiveTitle1', lives(:test_4).title
    assert_nil lives(:test_5).duration
    assert_equal 'UpdatedLiveTitle2', lives(:test_5).title
    assert_in_delta (Time.now + 1.day), lives(:test_5).start_at, 2
    assert_nil lives(:test_6).duration
    assert_equal 'StartedScheduledTitle', lives(:test_6).title
    assert_in_delta Time.now, lives(:test_6).start_at, 2
  end

  test 'should sync lives' do # rubocop:todo Metrics/BlockLength
    channel = channels(:test_1)
    live_infos = {
      'TestRoom4' => { 'title' => 'UpdatedLiveTitle1' },
      'TestRoom5' => {
        'title' => 'UpdatedLiveTitle2',
        'startAt' => (Time.now + 1.day).to_i
      },
      'TestRoom6' => { 'title' => 'StartedScheduledTitle' },
      'NewRoom' => { 'title' => 'NewLiveTitle1' },
      'ScheduledRoom' => {
        'title' => 'NewLiveTitle2',
        'startAt' => (Time.now + 1.day).to_i
      }
    }

    assert_equal 4, Room.open(channel).size

    LivesDetectJob.sync_live_rooms channel, live_infos

    assert_equal 5, Room.open(channel).reload.size
    assert_not_nil lives(:test_1).duration
    assert_nil lives(:test_4).duration
    assert_equal 'UpdatedLiveTitle1', lives(:test_4).title
    assert_in_delta Time.mktime(2020, 3, 27, 8), lives(:test_4).start_at, 2
    assert_nil lives(:test_5).duration
    assert_equal 'UpdatedLiveTitle2', lives(:test_5).title
    assert_in_delta (Time.now + 1.day), lives(:test_5).start_at, 2
    assert_nil lives(:test_6).duration
    assert_equal 'StartedScheduledTitle', lives(:test_6).title
    assert_in_delta Time.now, lives(:test_6).start_at, 2
    assert_not_nil Room.find_by_room('NewRoom')
    assert_not_nil Live.find_by_title('NewLiveTitle1')
    assert_in_delta(
      Time.now,
      Live.find_by_title('NewLiveTitle1').start_at,
      2
    )
    assert_not_nil Room.find_by_room('ScheduledRoom')
    assert_not_nil Live.find_by_title('NewLiveTitle2')
    assert_in_delta(
      Time.now + 1.day,
      Live.find_by_title('NewLiveTitle2').start_at,
      2
    )
  end
end
# rubocop:enable Metrics/ClassLength
