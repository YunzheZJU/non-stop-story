# frozen_string_literal: true

require 'test_helper'

class MemberTest < ActiveSupport::TestCase
  test 'should succeed to save' do
    member = Member.new name: 'NewMember',
                        avatar: 'https://example.com',
                        color_main: '#000000',
                        color_sub: '#ffffff'

    assert member.valid?
    assert member.save
  end

  test 'should fail to save nil name' do
    absent_name = Member.new avatar: 'https://example.com',
                             color_main: '#000000',
                             color_sub: '#ffffff'
    nil_name = Member.new name: nil,
                          avatar: 'https://example.com',
                          color_main: '#000000',
                          color_sub: '#ffffff'
    empty_name = Member.new name: '',
                            avatar: 'https://example.com',
                            color_main: '#000000',
                            color_sub: '#ffffff'

    assert_not absent_name.valid?
    assert_not absent_name.save
    assert_not nil_name.valid?
    assert_not nil_name.save
    assert_not empty_name.valid?
    assert_not empty_name.save
  end

  test 'should succeed to save nil avatar' do
    absent_avatar = Member.new name: 'TestMember',
                               color_main: '#000000',
                               color_sub: '#ffffff'

    assert absent_avatar.valid?
    assert absent_avatar.save
    assert_equal '', absent_avatar.avatar
  end

  test 'should succeed to save nil color' do
    absent_main_color = Member.new name: 'TestMember',
                                   color_main: '#000000'
    absent_sub_color = Member.new name: 'TestMember',
                                  color_sub: '#ffffff'

    assert absent_main_color.valid?
    assert absent_main_color.save
    assert absent_sub_color.valid?
    assert absent_sub_color.save
  end

  test 'should fail to save invalid color' do
    invalid_main_color = Member.new name: 'TestMember',
                                    color_main: 'invalid'
    invalid_sub_color = Member.new name: 'TestMember',
                                   color_sub: 'invalid'

    assert_not invalid_main_color.valid?
    assert_not invalid_main_color.save
    assert_not invalid_sub_color.valid?
    assert_not invalid_sub_color.save
  end
end
