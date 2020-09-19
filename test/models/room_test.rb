# frozen_string_literal: true

require 'test_helper'

class RoomTest < ActiveSupport::TestCase
  setup do
    @room_youtube = {
      room: 'abcdef', platform: platforms(:youtube)
    }
    @room_bilibili = {
      room: '123456', platform: platforms(:bilibili)
    }
  end

  test 'should succeed to save' do
    youtube = Room.new @room_youtube
    bilibili = Room.new @room_bilibili

    assert youtube.valid?
    assert bilibili.valid?
    assert youtube.save
    assert bilibili.save
  end

  test 'should fail to save invalid format' do
    bilibili = Room.new @room_bilibili.merge(room: 'abcdef')

    assert_not bilibili.valid?
    assert_not bilibili.save
  end

  test 'should fail to save nil platform' do
    absent_platform = Room.new @room_youtube.except(:platform)
    nil_platform = Room.new @room_youtube.merge(platform: nil)

    assert_not absent_platform.valid?
    assert_not absent_platform.save
    assert_not nil_platform.valid?
    assert_not nil_platform.save
  end

  test 'should scope open' do
    rooms = Room.open channels(:test_1)

    assert_equal 4, rooms.size
    assert_not_includes rooms, rooms(:test_2), rooms(:test_3)
  end
end
