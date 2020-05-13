# frozen_string_literal: true

require 'test_helper'

class ChannelTest < ActiveSupport::TestCase
  test 'should succeed to save' do
    youtube = Channel.new(
      channel: 'UC123456',
      platform: platforms(:youtube),
      member: members(:test_1)
    )
    bilibili = Channel.new(
      channel: '123456',
      platform: platforms(:bilibili),
      member: members(:test_1)
    )

    assert youtube.valid?
    assert bilibili.valid?
    assert youtube.save
    assert bilibili.save
  end

  test 'should succeed to save optional member' do
    optional_member = Channel.new(
      channel: 'UC123456',
      platform: platforms(:youtube)
    )

    assert optional_member.valid?
    assert optional_member.save
  end

  test 'should fail to save invalid format' do
    youtube = Channel.new(
      channel: 'UC123456',
      platform: platforms(:bilibili),
      member: members(:test_1)
    )
    bilibili = Channel.new(
      channel: '123456',
      platform: platforms(:youtube),
      member: members(:test_1)
    )

    assert_not youtube.valid?
    assert_not bilibili.valid?
    assert_not youtube.save
    assert_not bilibili.save
  end

  test 'should fail to save nil platform' do
    absent_platform = Channel.new(
      channel: 'UC123456',
      member: members(:test_1)
    )
    nil_platform = Channel.new(
      channel: 'UC123456',
      platform: nil,
      member: members(:test_1)
    )

    assert_not absent_platform.valid?
    assert_not absent_platform.save
    assert_not nil_platform.valid?
    assert_not nil_platform.save
  end
end
