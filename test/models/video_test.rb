# frozen_string_literal: true

require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  test 'should succeed to save' do
    video = Video.new(
      title: 'NewVideoTitle',
      video: 'NewVideo',
      duration: 1000,
      platform: platforms(:youtube)
    )

    assert video.valid?
    assert video.save
  end

  test 'should fail to save invalid format' do
    invalid = Video.new(
      title: 'NewVideoTitle',
      video: 'NewVideo',
      duration: 1000,
      platform: platforms(:bilibili)
    )

    assert_not invalid.valid?
    assert_not invalid.save
  end

  test 'should fail to save nil platform' do
    absent_platform = Video.new(
      title: 'NewVideoTitle',
      video: 'NewVideo',
      duration: 1000,
    )
    nil_platform = Video.new(
      title: 'NewVideoTitle',
      video: 'NewVideo',
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
      title: 'NewVideoTitle',
      video: 'NewVideo',
      duration: 0,
      platform: platforms(:youtube)
    )
    negative_duration = Video.new(
      title: 'NewVideoTitle',
      video: 'NewVideo',
      duration: -1,
      platform: platforms(:youtube)
    )

    assert_not zero_duration.valid?
    assert_not zero_duration.save
    assert_not negative_duration.valid?
    assert_not negative_duration.save
  end
end
