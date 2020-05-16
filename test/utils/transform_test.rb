# frozen_string_literal: true

require 'test_helper'
require 'utils/transform'

class TransformTest < ActionView::TestCase
  test 'allocate' do
    w1 = %w[w1]
    w3 = %w[w1 w2 w3]
    c1 = %w[c1]
    c6 = %w[c1 c2 c3 c4 c5 c6]
    c7 = %w[c1 c2 c3 c4 c5 c6 c7]
    assert_equal({ 'w1' => %w[c1] }, Transform.allocate(w1, c1))
    assert_equal({ 'w1' => %w[c1] }, Transform.allocate(w3, c1))
    assert_equal(
      { 'w1' => %w[c1 c4], 'w2' => %w[c2 c5], 'w3' => %w[c3 c6] },
      Transform.allocate(w3, c6)
    )
    assert_equal(
      { 'w1' => %w[c1 c4 c7], 'w2' => %w[c2 c5], 'w3' => %w[c3 c6] },
      Transform.allocate(w3, c7)
    )
  end
end
