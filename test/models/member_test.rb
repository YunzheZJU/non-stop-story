# frozen_string_literal: true

require 'test_helper'

class MemberTest < ActiveSupport::TestCase
  setup do
    @member = {
      name: 'NewMember',
      avatar: 'https://example.com',
      color_main: '#000000',
      color_sub: '#ffffff',
      graduated: false
    }
  end

  test 'should succeed to save' do
    member = Member.new @member

    assert member.valid?
    assert member.save
  end

  test 'should fail to save nil name' do
    absent_name = Member.new @member.except(:name)
    nil_name = Member.new @member.merge(name: nil)
    empty_name = Member.new @member.merge(name: '')

    assert_not absent_name.valid?
    assert_not absent_name.save
    assert_not nil_name.valid?
    assert_not nil_name.save
    assert_not empty_name.valid?
    assert_not empty_name.save
  end

  test 'should succeed to save nil avatar' do
    absent_avatar = Member.new @member.except(:avatar)

    assert absent_avatar.valid?
    assert absent_avatar.save
    assert_equal '', absent_avatar.avatar
  end

  test 'should succeed to save nil graduated' do
    absent_graduated = Member.new @member.except(:graduated)

    assert absent_graduated.valid?
    assert absent_graduated.save
    assert_equal false, absent_graduated.graduated
  end

  test 'should succeed to save nil color' do
    absent_main_color = Member.new @member.except(:color_sub)
    absent_sub_color = Member.new @member.except(:color_main)

    assert absent_main_color.valid?
    assert absent_main_color.save
    assert absent_sub_color.valid?
    assert absent_sub_color.save
  end

  test 'should fail to save invalid color' do
    invalid_main_color = Member.new @member.merge(color_main: 'invalid')
    invalid_sub_color = Member.new @member.merge(color_sub: 'invalid')

    assert_not invalid_main_color.valid?
    assert_not invalid_main_color.save
    assert_not invalid_sub_color.valid?
    assert_not invalid_sub_color.save
  end

  test 'should scope active' do
    member = Member.active

    assert_equal 2, member.size
    assert_not_includes member, members(:test_1)
  end
end
