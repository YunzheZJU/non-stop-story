# frozen_string_literal: true

class Live < ApplicationRecord
  belongs_to :channel
  belongs_to :room
  has_many :clip
  has_many :hotnesses
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
  scope :open, -> { where(duration: nil) }
  scope :current, -> { open.start_before(Time.current) }
  scope :scheduled, -> { open.start_after(Time.current) }
  scope :active, lambda {
    open.or(ended.where('lives.updated_at >= ?', 5.minutes.ago))
  }
end
