# frozen_string_literal: true

require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  test 'should succeed to save' do
    youtube = Video.new(
      title: 'sakurakaze',
      video: 'WQhBCy6usZA',
      duration: 1000,
      platform: platforms(:youtube)
    )
    bilibili = Video.new(
      title: 'untildawn',
      video: 'BV1Va4y1i7sv',
      duration: 1000,
      platform: platforms(:bilibili)
    )

    assert youtube.valid?
    assert bilibili.valid?
    assert youtube.save
    assert bilibili.save
  end

  test 'should fail to save invalid format' do
    youtube = Video.new(
      title: 'sakurakaze',
      video: 'WQhBCy6usZA',
      duration: 1000,
      platform: platforms(:bilibili)
    )

    assert_not youtube.valid?
    assert_not youtube.save
  end

  test 'should fail to save nil platform' do
    absent_platform = Video.new(
      title: 'sakurakaze',
      video: 'WQhBCy6usZA',
      duration: 1000
    )
    nil_platform = Video.new(
      title: 'sakurakaze',
      video: 'WQhBCy6usZA',
      duration: 1000,
      platform: nil
    )

    assert_not absent_platform.valid?
    assert_not absent_platform.save
    assert_not nil_platform.valid?
    assert_not nil_platform.save
  end

  test 'should fail to save negative duration' do
    zero_duration = Video.new(
      title: 'sakurakaze',
      video: 'WQhBCy6usZA',
      duration: 0,
      platform: platforms(:youtube)
    )
    negative_duration = Video.new(
      title: 'sakurakaze',
      video: 'WQhBCy6usZA',
      duration: -1,
      platform: platforms(:youtube)
    )

    assert_not zero_duration.valid?
    assert_not zero_duration.save
    assert_not negative_duration.valid?
    assert_not negative_duration.save
  end
end
