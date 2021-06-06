# frozen_string_literal: true

class Hotness < ApplicationRecord
  belongs_to :live
  validates :live, presence: true
  validates :watching, if: :watching, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
  }
  validates :like, if: :like, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
  }

  default_scope { order(:created_at) }
  scope :of_lives, ->(lives) { where(live: lives) if lives.present? }
end
