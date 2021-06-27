# frozen_string_literal: true

require 'test_helper'

class HotnessTest < ActiveSupport::TestCase
  setup do
    @hotness = {
      live: lives(:test_1),
      watching: 100,
      like: 200,
    }
  end

  test 'should succeed to save' do
    hotness = Hotness.new @hotness

    assert hotness.valid?
    assert hotness.save
  end

  test 'should succeed to save optional watching and like' do
    optional_watching = Hotness.new @hotness.except(:watching)
    optional_like = Hotness.new @hotness.except(:like)

    assert optional_watching.valid?
    assert optional_like.valid?
    assert optional_watching.save
    assert optional_like.save
  end

  test 'should fail to save negative watching or like' do
    zero_watching = Hotness.new @hotness.merge(watching: 0)
    negative_watching = Hotness.new @hotness.merge(watching: -1)
    zero_like = Hotness.new @hotness.merge(like: 0)
    negative_like = Hotness.new @hotness.merge(like: -1)

    assert zero_watching.valid?
    assert zero_watching.save
    assert_not negative_watching.valid?
    assert_not negative_watching.save
    assert zero_like.valid?
    assert zero_like.save
    assert_not negative_like.valid?
    assert_not negative_like.save
  end

  test 'should fail to save absent live' do
    absent_live = Hotness.new @hotness.except(:live)

    assert_not absent_live.valid?
    assert_not absent_live.save
  end

  test 'should use default scope' do
    hotnesses = Hotness.all
    hotnesses.reduce do |prev, current|
      assert prev.created_at <= current.created_at
      prev
    end
  end

  test 'should scope created_after' do
    hotnesses = Hotness.created_after Time.zone.parse('2020-03-27 00:02:00')

    assert_equal 3, hotnesses.size
    assert_includes hotnesses, hotnesses(:test_1)
    assert_includes hotnesses, hotnesses(:test_2)
    assert_includes hotnesses, hotnesses(:test_4)
  end

  test 'should scope created_before' do
    hotnesses = Hotness.created_before Time.zone.parse('2020-03-27 00:02:00')

    assert_equal 1, hotnesses.size
    assert_includes hotnesses, hotnesses(:test_3)
  end

  test 'should scope of_lives' do
    hotnesses_one = Hotness.of_lives([lives(:test_1), lives(:test_2)])
    hotnesses_two = Hotness.of_lives(lives(:test_2))
    hotnesses_three = Hotness.of_lives(lives(:test_3))
    hotnesses_four = Hotness.of_lives(nil)

    assert_equal 3, hotnesses_one.size
    assert_not_includes hotnesses_two, hotnesses(:test_1)
    assert_equal 2, hotnesses_two.size
    assert_equal 0, hotnesses_three.size
    assert_equal 4, hotnesses_four.size
  end
end
