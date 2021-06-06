# frozen_string_literal: true

class Live < ApplicationRecord
  belongs_to :channel
  belongs_to :room
  has_many :clip
  belongs_to :video, optional: true
  validates :title, presence: true
  validates :start_at, presence: true
  validates :duration, if: :duration, numericality: {
    only_integer: true,
    greater_than: 0,
  }

  scope :of_channels, lambda { |channels|
    where(channel: channels) if channels.present?
  }
  scope :start_after, lambda { |time|
    where('lives.start_at >= ?', time) if time.present?
  }
  scope :start_before, lambda { |time|
    where('lives.start_at < ?', time) if time.present?
  }
  scope :ended, -> { where.not(duration: nil) }
  scope :not_ended, -> { where(duration: nil) }
  scope :current, -> { not_ended.start_before(Time.current) }
  scope :scheduled, -> { not_ended.start_after(Time.current) }
  scope :active, lambda {
    not_ended.or(ended.where('lives.updated_at >= ?', 5.minutes.ago))
  }
end
