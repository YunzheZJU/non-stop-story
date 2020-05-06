# frozen_string_literal: true

require 'test_helper'

class RoomTest < ActiveSupport::TestCase
  test 'should succeed to save' do
    youtube = Room.new room: 'abcdef', platform: platforms(:youtube)
    bilibili = Room.new room: '123456', platform: platforms(:bilibili)

    assert youtube.valid?
    assert bilibili.valid?
    assert youtube.save
    assert bilibili.save
  end

  test 'should fail to save invalid format' do
    youtube = Room.new room: 'abcdef', platform: platforms(:bilibili)

    assert_not youtube.valid?
    assert_not youtube.save
  end

  test 'should fail to save nil platform' do
    absent_platform = Room.new room: 'abcdef'
    nil_platform = Room.new room: 'abcdef', platform: nil

    assert_not absent_platform.valid?
    assert_not absent_platform.save
    assert_not nil_platform.valid?
    assert_not nil_platform.save
  end
end
