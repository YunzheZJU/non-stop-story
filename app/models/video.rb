# frozen_string_literal: true

class Video < ApplicationRecord
  belongs_to :platform
  has_one :live
  has_one :arrange
  validates :title, presence: true
  validates :duration, presence: true, numericality: {
    only_integer: true,
    greater_than: 0,
  }
  validates :video, presence: true
  validate :validate_video_format

  def validate_video_format
    return unless platform.present?

    format_by_platform = { youtube: /^\w+$/,
                           bilibili: /^(av\d+|bv\w+)$/i,
                           twitch: /^\d+$/,
                           twitcasting: /^\d+$/, }

    return if video =~ format_by_platform[platform.platform.to_sym]

    errors.add(:video, "format is invalid #{video}")
  end
end
