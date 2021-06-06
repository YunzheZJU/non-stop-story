# frozen_string_literal: true

class Channel < ApplicationRecord
  has_many :lives
  belongs_to :platform
  belongs_to :member, optional: true
  belongs_to :editor, optional: true
  validate :validate_channel_format

  scope :of_platforms, lambda { |platforms|
    where(platform: platforms) if platforms.present?
  }
  scope :of_members, lambda { |members|
    where(member: members) if members.present?
  }

  def validate_channel_format
    return unless platform.present?

    format_by_platform = { youtube: /^UC[\w-]+$/,
                           bilibili: /^\d+$/,
                           twitch: /^[\w_]+$/, }

    return if channel =~ format_by_platform[platform.platform.to_sym]

    errors.add(:channel, "format is invalid #{channel}")
  end
end
