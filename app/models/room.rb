# frozen_string_literal: true

class Room < ApplicationRecord
  belongs_to :platform
  has_many :lives
  validates :room, presence: true
  validate :validate_room_format

  scope :open, lambda { |channel|
    joins(:platform, :lives)
      .where(lives: { duration: nil, channel: channel },
             platform: channel.platform)
  }

  def validate_room_format
    return unless platform.present?

    format = case platform.platform
             when 'youtube'
               /^[\w-]+$/
             when 'bilibili'
               /^\d+$/
             when 'twitch'
               /^[\w_]+$/
             else
               /^.*$/
             end
    errors.add(:room, "format is invalid #{room}") unless room =~ format
  end
end
