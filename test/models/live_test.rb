# frozen_string_literal: true

require 'test_helper'

class LiveTest < ActiveSupport::TestCase
  test 'should succeed to save' do
    sakurakaze = Live.new(
      title: 'サクラカゼ',
      start_at: Time.mktime(2020, 3, 27, 0, 0, 0),
      member: members(:sakuramiko),
      room: rooms(:channel_X9zw0QF12Kc),
      duration: 500,
      video: videos(:video_sakurakaze)
    )
    untildawn = Live.new(
      title: '直到黎明',
      start_at: Time.mktime(2020, 5, 7, 0, 0, 0),
      member: members(:sakuramiko),
      room: rooms(:channel_21144047),
      duration: 1500,
      video: videos(:video_untildawn)
    )

    assert sakurakaze.valid?
    assert untildawn.valid?
    assert sakurakaze.save
    assert untildawn.save
  end

  test 'should succeed to save optional duration and video' do
    optional_duration = Live.new(
      title: 'サクラカゼ',
      start_at: Time.mktime(2020, 3, 27, 0, 0, 0),
      member: members(:sakuramiko),
      room: rooms(:channel_X9zw0QF12Kc),
      video: videos(:video_sakurakaze)
    )
    optional_video = Live.new(
      title: '直到黎明',
      start_at: Time.mktime(2020, 5, 7, 0, 0, 0),
      member: members(:sakuramiko),
      room: rooms(:channel_21144047),
      duration: 1500
    )

    assert optional_duration.valid?
    assert optional_video.valid?
    assert optional_duration.save
    assert optional_video.save
  end

  test 'should fail to save absent field' do
    absent_title = Live.new(
      start_at: Time.mktime(2020, 3, 27, 0, 0, 0),
      member: members(:sakuramiko),
      room: rooms(:channel_X9zw0QF12Kc),
      duration: 500,
      video: videos(:video_sakurakaze)
    )
    absent_member = Live.new(
      title: 'サクラカゼ',
      start_at: Time.mktime(2020, 3, 27, 0, 0, 0),
      room: rooms(:channel_X9zw0QF12Kc),
      duration: 1500,
      video: videos(:video_untildawn)
    )

    assert_not absent_title.valid?
    assert_not absent_title.save
    assert_not absent_member.valid?
    assert_not absent_member.save
  end

  test 'should fail to save negative duration' do
    zero_duration = Live.new(
      title: 'サクラカゼ',
      start_at: Time.mktime(2020, 3, 27, 0, 0, 0),
      member: members(:sakuramiko),
      room: rooms(:channel_X9zw0QF12Kc),
      duration: 0,
      video: videos(:video_sakurakaze)
    )
    negative_duration = Live.new(
      title: 'サクラカゼ',
      start_at: Time.mktime(2020, 3, 27, 0, 0, 0),
      member: members(:sakuramiko),
      room: rooms(:channel_X9zw0QF12Kc),
      duration: -1,
      video: videos(:video_untildawn)
    )

    assert_not zero_duration.valid?
    assert_not zero_duration.save
    assert_not negative_duration.valid?
    assert_not negative_duration.save
  end
end
