# frozen_string_literal: true

require 'test_helper'

class ArrangeTest < ActiveSupport::TestCase
  test 'should succeed to save' do
    arrange = Arrange.new(
      video: videos(:video_sakurakaze),
      clips: [clips(:clip)],
      editors: [editors(:editor)]
    )

    assert arrange.valid?
    assert arrange.save
  end

  test 'should succeed to save optional clips and editors' do
    optional_clips = Arrange.new(
      video: videos(:video_sakurakaze),
      editors: [editors(:editor)]
    )
    optional_editors = Arrange.new(
      video: videos(:video_sakurakaze),
      clips: [clips(:clip)]
    )

    assert optional_clips.valid?
    assert optional_clips.save
    assert optional_editors.valid?
    assert optional_editors.save
  end

  test 'should fail to save nil video' do
    absent_video = Arrange.new(
      clips: [clips(:clip)],
      editors: [editors(:editor)]
    )
    nil_video = Arrange.new(
      video: nil,
      clips: [clips(:clip)],
      editors: [editors(:editor)]
    )

    assert_not absent_video.valid?
    assert_not absent_video.save
    assert_not nil_video.valid?
    assert_not nil_video.save
  end
end
