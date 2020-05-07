# frozen_string_literal: true

class Live < ApplicationRecord
  belongs_to :member
  belongs_to :room
  has_many :clip
  belongs_to :video, optional: true
  validates :title, presence: true
  validates :start_at, presence: true
  validates :duration, if: :duration, numericality: {
    only_integer: true,
    greater_than: 0
  }
end
