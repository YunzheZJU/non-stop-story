# frozen_string_literal: true

require 'test_helper'

class ChannelTest < ActiveSupport::TestCase
  setup do
    @channel_youtube = {
      channel: 'UC123456',
      platform: platforms(:youtube),
      member: members(:test_1)
    }
    @channel_bilibili = {
      channel: '123456',
      platform: platforms(:bilibili),
      member: members(:test_1)
    }
  end

  test 'should succeed to save' do
    youtube = Channel.new @channel_youtube
    bilibili = Channel.new @channel_bilibili

    assert youtube.valid?
    assert bilibili.valid?
    assert youtube.save
    assert bilibili.save
  end

  test 'should succeed to save optional member' do
    optional_member = Channel.new @channel_youtube.except(:member)

    assert optional_member.valid?
    assert optional_member.save
  end

  test 'should fail to save invalid format' do
    youtube = Channel.new @channel_youtube.merge(channel: '123456')
    bilibili = Channel.new @channel_bilibili.merge(channel: 'UC123456')

    assert_not youtube.valid?
    assert_not bilibili.valid?
    assert_not youtube.save
    assert_not bilibili.save
  end

  test 'should fail to save nil platform' do
    absent_platform = Channel.new @channel_youtube.except(:platform)
    nil_platform = Channel.new @channel_youtube.merge(platform: nil)

    assert_not absent_platform.valid?
    assert_not absent_platform.save
    assert_not nil_platform.valid?
    assert_not nil_platform.save
  end

  test 'should scope of_platforms' do
    channels = Channel.of_platforms(platforms(:youtube))

    assert_equal 3, channels.size
    assert_not_includes channels, channels(:test_4)
  end

  test 'should scope of_members' do
    channels = Channel.of_members(members(:test_2))

    assert_equal 3, channels.size
    assert_not_includes channels, channels(:test_1)
  end
end
