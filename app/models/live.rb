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
  scope :of_members, lambda { |members|
    joins(:channel).merge(Channel.of_members(members)) if members.present?
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
    open.or(ended.where('lives.updated_at >= ?', 60.minutes.ago))
  }

  def cached_hotnesses
    Rails.cache.fetch(cache_key_with_version, expires_in: 24.hours) do
      hotnesses.map { |hotness| hotness.as_json(only: %i[watching like created_at]) }
    end
  end

  def json
    as_json(only: %i[id title duration start_at channel_id cover created_at]).merge!(
      room: room.room, platform: room.platform.platform, channel: channel.channel
    ).then { |live| duration.nil? ? live : live.merge!(hotnesses: cached_hotnesses) }
  end
end
