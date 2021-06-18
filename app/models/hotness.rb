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
  scope :created_after, lambda { |time|
    where('hotnesses.created_at >= ?', time) if time.present?
  }
  scope :created_before, lambda { |time|
    where('hotnesses.created_at < ?', time) if time.present?
  }
  scope :of_lives, lambda { |lives|
    return unless lives.present?

    Live.where(id: lives).map do |live|
      where(live: live).created_after(live.start_at)
                       .created_before(live.duration && (live.start_at + live.duration))
    end.inject(&:or) || where(live: -1)
  }
end
