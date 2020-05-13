# frozen_string_literal: true

require 'test_helper'

class ArrangeTest < ActiveSupport::TestCase
  test 'should succeed to save' do
    arrange = Arrange.new(
      video: videos(:test_2),
      clips: [clips(:test_1)],
      editors: [editors(:test_1)]
    )

    assert arrange.valid?
    assert arrange.save
  end

  test 'should succeed to save optional clips and editors' do
    optional_clips = Arrange.new(
      video: videos(:test_2),
      editors: [editors(:test_1)]
    )
    optional_editors = Arrange.new(
      video: videos(:test_2),
      clips: [clips(:test_1)]
    )

    assert optional_clips.valid?
    assert optional_clips.save
    assert optional_editors.valid?
    assert optional_editors.save
  end

  test 'should fail to save nil video' do
    absent_video = Arrange.new(
      clips: [clips(:test_1)],
      editors: [editors(:test_1)]
    )
    nil_video = Arrange.new(
      video: nil,
      clips: [clips(:test_1)],
      editors: [editors(:test_1)]
    )

    assert_not absent_video.valid?
    assert_not absent_video.save
    assert_not nil_video.valid?
    assert_not nil_video.save
  end
end
