# frozen_string_literal: true

require 'test_helper'

# rubocop:todo Metrics/ClassLength
class LiveTest < ActiveSupport::TestCase
  setup do
    @live = {
      title: 'NewLive',
      start_at: Time.current,
      channel: channels(:test_1),
      room: rooms(:test_1),
      duration: 500,
      video: videos(:test_1),
    }
  end

  test 'should succeed to save' do
    live = Live.new @live

    assert live.valid?
    assert live.save
  end

  test 'should succeed to save optional duration and video' do
    optional_duration = Live.new @live.except(:duration)
    optional_video = Live.new @live.except(:video)

    assert optional_duration.valid?
    assert optional_video.valid?
    assert optional_duration.save
    assert optional_video.save
  end

  test 'should fail to save absent field' do
    absent_title = Live.new @live.except(:title)
    absent_channel = Live.new @live.except(:channel)

    assert_not absent_title.valid?
    assert_not absent_title.save
    assert_not absent_channel.valid?
    assert_not absent_channel.save
  end

  test 'should fail to save negative duration' do
    zero_duration = Live.new @live.merge(duration: 0)
    negative_duration = Live.new @live.merge(duration: -1)

    assert_not zero_duration.valid?
    assert_not zero_duration.save
    assert_not negative_duration.valid?
    assert_not negative_duration.save
  end

  test 'should scope of_channels' do
    lives_from_channel_one = Live.of_channels channels(:test_1)
    lives_from_channel_two = Live.of_channels channels(:test_2)

    assert_equal 6, lives_from_channel_one.size
    assert_equal 0, lives_from_channel_two.size
  end

  test 'should scope of_members' do
    lives_from_member_one = Live.of_members members(:test_1)
    lives_from_member_two = Live.of_members members(:test_2)

    assert_equal 6, lives_from_member_one.size
    assert_equal 0, lives_from_member_two.size
  end

  test 'should scope start_after' do
    lives = Live.start_after Time.current

    assert_not_includes lives, lives(:test_1)
    assert_not_includes lives, lives(:test_2)
    assert_not_includes lives, lives(:test_3)
    assert_not_includes lives, lives(:test_4)
    assert_includes lives, lives(:test_5)
    assert_includes lives, lives(:test_6)
  end

  test 'should scope start_before' do
    lives = Live.start_before Time.current

    assert_includes lives, lives(:test_1)
    assert_includes lives, lives(:test_2)
    assert_includes lives, lives(:test_3)
    assert_includes lives, lives(:test_4)
    assert_not_includes lives, lives(:test_5)
    assert_not_includes lives, lives(:test_6)
  end

  test 'should scope ended' do
    lives = Live.ended

    assert_not_includes lives, lives(:test_1)
    assert_includes lives, lives(:test_2)
    assert_includes lives, lives(:test_3)
    assert_not_includes lives, lives(:test_4)
    assert_not_includes lives, lives(:test_5)
    assert_not_includes lives, lives(:test_6)
  end

  test 'should scope open' do
    lives = Live.open

    assert_includes lives, lives(:test_1)
    assert_not_includes lives, lives(:test_2)
    assert_not_includes lives, lives(:test_3)
    assert_includes lives, lives(:test_4)
    assert_includes lives, lives(:test_5)
    assert_includes lives, lives(:test_6)
  end

  test 'should scope current' do
    lives = Live.current

    assert_includes lives, lives(:test_1)
    assert_not_includes lives, lives(:test_2)
    assert_not_includes lives, lives(:test_3)
    assert_includes lives, lives(:test_4)
    assert_not_includes lives, lives(:test_5)
    assert_not_includes lives, lives(:test_6)
  end

  test 'should scope scheduled' do
    lives = Live.scheduled

    assert_not_includes lives, lives(:test_1)
    assert_not_includes lives, lives(:test_2)
    assert_not_includes lives, lives(:test_3)
    assert_not_includes lives, lives(:test_4)
    assert_includes lives, lives(:test_5)
    assert_includes lives, lives(:test_6)
  end

  test 'should scope active' do
    travel_to 1.hour.from_now do
      lives(:test_3).update!(cover: 'NewCover')
      lives(:test_7).update!(updated_at: 65.minutes.ago)

      lives = Live.active

      assert_equal 6, lives.size
      assert_not_includes lives, lives(:test_7)
    end
  end
end

# rubocop:enable Metrics/ClassLength
