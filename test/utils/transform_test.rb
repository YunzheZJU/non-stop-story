# frozen_string_literal: true

require 'test_helper'
require 'utils/transform'

class TransformTest < ActionView::TestCase
  test 'allocate' do
    w_1 = %w[w1]
    w_1_dup = %w[w1 w1]
    w_3 = %w[w1 w2 w3]
    c_1 = %w[c1]
    c_6 = %w[c1 c2 c3 c4 c5 c6]
    c_7 = %w[c1 c2 c3 c4 c5 c6 c7]
    assert_equal({ ['w1', 0] => %w[c1] }, Transform.allocate(w_1, c_1))
    assert_equal(
      { ['w1', 0] => %w[c1 c3 c5], ['w1', 1] => %w[c2 c4 c6] },
      Transform.allocate(w_1_dup, c_6)
    )
    assert_equal({ ['w1', 0] => %w[c1] }, Transform.allocate(w_3, c_1))
    assert_equal(
      { ['w1', 0] => %w[c1 c4], ['w2', 1] => %w[c2 c5],
        ['w3', 2] => %w[c3 c6], },
      Transform.allocate(w_3, c_6)
    )
    assert_equal(
      { ['w1', 0] => %w[c1 c4 c7], ['w2', 1] => %w[c2 c5],
        ['w3', 2] => %w[c3 c6], },
      Transform.allocate(w_3, c_7)
    )
  end
end
