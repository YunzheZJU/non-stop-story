# frozen_string_literal: true

require 'test_helper'

class EditorTest < ActiveSupport::TestCase
  test 'should succeed to save' do
    editor = Editor.new name: '樱巫女Official', arranges: [arranges(:arrange)]

    assert editor.valid?
    assert editor.save
  end

  test 'should succeed to save optional arranges' do
    optional_arranges = Editor.new name: '樱巫女Official'

    assert optional_arranges.valid?
    assert optional_arranges.save
  end

  test 'should fail to save nil name' do
    absent_name = Editor.new
    nil_name = Editor.new name: nil
    empty_name = Editor.new name: ''

    assert_not absent_name.valid?
    assert_not absent_name.save
    assert_not nil_name.valid?
    assert_not nil_name.save
    assert_not empty_name.valid?
    assert_not empty_name.save
  end
end
