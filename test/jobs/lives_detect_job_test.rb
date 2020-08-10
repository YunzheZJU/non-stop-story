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

    assert_difference('Room.open(channel).count', -4) do
      LivesDetectJob.close_or_delete_lives open_room_vals - room_vals
    end

    assert_not_nil lives(:test_1).duration
    assert_not_nil lives(:test_4).duration
    assert_raise(StandardError) { lives(:test_5) }
    assert_raise(StandardError) { rooms(:test_5) }
    assert_raise(StandardError) { lives(:test_6) }
    assert_raise(StandardError) { rooms(:test_6) }
  end

  test 'should extend lives' do
    channel = channels(:test_1)
    live_infos = {
      'TestRoom2' => { 'title' => 'Create a new live' },
      # Note: Extending a live will not update the title immediately
      'TestRoom3' => { 'title' => 'Extend an existing live' }
    }

    room_vals = live_infos.to_a.map { |room, _live_info| room }
    open_room_vals = Room.open(channel).pluck('room')

    travel_to Time.zone.parse('2020-03-27 0:31:00') do
      assert_difference('Room.open(channel).count', 2) do
        LivesDetectJob.extend_or_create_lives(
          live_infos.select do |room|
            (room_vals - open_room_vals).include? room
          end,
          channel
        )
      end
    end

    assert_not_nil Live.find_by_title('Create a new live')
    assert_not_nil lives(:test_2).duration
    assert_nil lives(:test_3).duration
  end

  test 'should create lives' do # rubocop:todo Metrics/BlockLength
    channel = channels(:test_1)
    live_infos = {
      'NewRoom' => { 'title' => 'NewLiveTitle1', 'cover' => 'NewCover1' },
      'ScheduledRoom' => {
        'title' => 'NewLiveTitle2',
        'startAt' => (Time.now + 1.day).to_i
      }
    }

    room_vals = live_infos.to_a.map { |room, _live_info| room }
    open_room_vals = Room.open(channel).pluck('room')

    assert_difference('Room.open(channel).count', 2) do
      LivesDetectJob.extend_or_create_lives(
        live_infos.select { |room| (room_vals - open_room_vals).include? room },
        channel
      )
    end

    assert_not_nil Room.find_by_room('NewRoom')
    assert_not_nil Live.find_by_title('NewLiveTitle1')
    assert_not_nil Live.find_by_cover('NewCover1')
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

  test 'should update lives' do # rubocop:todo Metrics/BlockLength
    channel = channels(:test_1)
    live_infos = {
      'TestRoom4' => { 'title' => 'UpdatedLiveTitle1', 'cover' => 'NewCover1' },
      'TestRoom5' => {
        'title' => 'UpdatedLiveTitle2',
        'startAt' => (Time.now + 1.day).to_i
      },
      'TestRoom6' => { 'title' => 'StartedScheduledTitle' }
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
    assert_in_delta (Time.now + 1.day), lives(:test_5).start_at, 2
    assert_nil lives(:test_5).cover
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

    assert_difference('Room.open(channel).count', 1) do
      LivesDetectJob.sync_live_rooms channel, live_infos
    end

    assert_not_nil lives(:test_1).duration
    assert_nil lives(:test_4).duration
    assert_equal 'UpdatedLiveTitle1', lives(:test_4).title
    assert_in_delta Time.zone.parse('2020-03-27 0:00:00'), lives(:test_4).start_at, 2
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
