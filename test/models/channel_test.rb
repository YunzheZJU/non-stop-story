# frozen_string_literal: true

require 'test_helper'

class ChannelTest < ActiveSupport::TestCase
  test 'should succeed to save' do
    youtube = Channel.new channel: 'UC123456', platform: platforms(:youtube)
    bilibili = Channel.new channel: '123456', platform: platforms(:bilibili)

    assert youtube.valid?
    assert bilibili.valid?
    assert youtube.save
    assert bilibili.save
  end

  test 'should fail to save invalid format' do
    youtube = Channel.new channel: 'UC123456', platform: platforms(:bilibili)
    bilibili = Channel.new channel: '123456', platform: platforms(:youtube)

    assert_not youtube.valid?
    assert_not bilibili.valid?
    assert_not youtube.save
    assert_not bilibili.save
  end

  test 'should fail to save nil platform' do
    absent_platform = Channel.new channel: 'UC123456'
    nil_platform = Channel.new channel: 'UC123456', platform: nil

    assert_not absent_platform.valid?
    assert_not absent_platform.save
    assert_not nil_platform.valid?
    assert_not nil_platform.save
  end
end
