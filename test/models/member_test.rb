# frozen_string_literal: true

require 'test_helper'

class MemberTest < ActiveSupport::TestCase
  test 'should succeed to save' do
    sakuramiko = Member.new name: 'さくらみこ'

    assert sakuramiko.valid?
    assert sakuramiko.save
  end

  test 'should fail to save nil name' do
    absent_name = Member.new
    nil_name = Member.new name: nil
    empty_name = Member.new name: ''

    assert_not absent_name.valid?
    assert_not absent_name.save
    assert_not nil_name.valid?
    assert_not nil_name.save
    assert_not empty_name.valid?
    assert_not empty_name.save
  end
end
