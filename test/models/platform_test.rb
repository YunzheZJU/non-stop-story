# frozen_string_literal: true

require 'test_helper'

class PlatformTest < ActiveSupport::TestCase
  test 'should succeed to save' do
    youtube = Platform.new platform: 'youtube'

    assert youtube.valid?
    assert youtube.new_record?
    assert youtube.save
    assert_not youtube.new_record?
  end

  test 'should fail to save' do
    invalid = Platform.new platform: 'invalid'

    assert invalid.invalid?
    assert invalid.new_record?
    assert_not invalid.save
    assert invalid.new_record?
  end
end
