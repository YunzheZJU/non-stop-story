# frozen_string_literal: true

require 'test_helper'

class ClipTest < ActiveSupport::TestCase
  test 'should succeed to save' do
    clip = Clip.new(
      in_time: 0,
      out_time: 2000,
      live: lives(:live_untildawn),
      arranges: [arranges(:arrange)]
    )

    assert clip.valid?
    assert clip.save
  end

  test 'should succeed to save optional arranges' do
    optional_arranges = Clip.new(
      in_time: 0,
      out_time: 2000,
      live: lives(:live_untildawn)
    )

    assert optional_arranges.valid?
    assert optional_arranges.save
  end

  test 'should fail to save invalid in_time' do
    zero_in_time = Clip.new(
      in_time: -1,
      out_time: 2000,
      live: lives(:live_untildawn)
    )
    overflow_in_time = Clip.new(
      in_time: 1001,
      out_time: 1000,
      live: lives(:live_untildawn)
    )

    assert_not zero_in_time.valid?
    assert_not zero_in_time.save
    assert_not overflow_in_time.valid?
    assert_not overflow_in_time.save
  end

  test 'should fail to save live without duration' do
    invalid_live = Clip.new(
      in_time: 0,
      out_time: 1,
      live: lives(:live_sakurakaze)
    )

    assert_not invalid_live.valid?
    assert_not invalid_live.save
  end

  test 'should fail to save invalid out_time' do
    overflow_out_time = Clip.new(
      in_time: 0,
      out_time: 2001,
      live: lives(:live_untildawn)
    )

    assert_not overflow_out_time.valid?
    assert_not overflow_out_time.save
  end
end
