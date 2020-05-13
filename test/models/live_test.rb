# frozen_string_literal: true

require 'test_helper'

class LiveTest < ActiveSupport::TestCase
  test 'should succeed to save' do
    live = Live.new(
      title: 'NewLive',
      start_at: Time.now,
      member: members(:test_1),
      room: rooms(:test_1),
      duration: 500,
      video: videos(:test_1)
    )

    assert live.valid?
    assert live.save
  end

  test 'should succeed to save optional duration and video' do
    optional_duration = Live.new(
      title: 'NewLive',
      start_at: Time.now,
      member: members(:test_1),
      room: rooms(:test_1),
      video: videos(:test_1)
    )
    optional_video = Live.new(
      title: 'NewLive',
      start_at: Time.now,
      member: members(:test_1),
      room: rooms(:test_1),
      duration: 500
    )

    assert optional_duration.valid?
    assert optional_video.valid?
    assert optional_duration.save
    assert optional_video.save
  end

  test 'should fail to save absent field' do
    absent_title = Live.new(
      start_at: Time.now,
      member: members(:test_1),
      room: rooms(:test_1),
      duration: 500,
      video: videos(:test_1)
    )
    absent_member = Live.new(
      title: 'サクラカゼ',
      start_at: Time.now,
      room: rooms(:test_1),
      duration: 500,
      video: videos(:test_1)
    )

    assert_not absent_title.valid?
    assert_not absent_title.save
    assert_not absent_member.valid?
    assert_not absent_member.save
  end

  test 'should fail to save negative duration' do
    zero_duration = Live.new(
      title: 'サクラカゼ',
      start_at: Time.now,
      member: members(:test_1),
      room: rooms(:test_1),
      duration: 0,
      video: videos(:test_1)
    )
    negative_duration = Live.new(
      title: 'サクラカゼ',
      start_at: Time.now,
      member: members(:test_1),
      room: rooms(:test_1),
      duration: -1,
      video: videos(:test_1)
    )

    assert_not zero_duration.valid?
    assert_not zero_duration.save
    assert_not negative_duration.valid?
    assert_not negative_duration.save
  end
end
