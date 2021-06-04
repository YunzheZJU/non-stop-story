# frozen_string_literal: true

class Room < ApplicationRecord
  belongs_to :platform
  has_many :lives
  validates :room, presence: true
  validate :validate_room_format

  scope :open, lambda { |channel|
    joins(:lives).merge(Live.not_ended.of_channels(channel))
  }

  def validate_room_format
    return unless platform.present?

    format_by_platform = { youtube: /^[\w-]+$/,
                           bilibili: /^\d+$/,
                           twitch: /^[\w_]+$/ }

    return if room =~ format_by_platform[platform.platform.to_sym]

    errors.add(:room, "format is invalid #{room}")
  end
end
