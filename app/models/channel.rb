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

    format = case platform.platform
             when 'youtube'
               /^UC[\w-]+$/
             when 'bilibili'
               /^\d+$/
             when 'twitch'
               /^[\w_]+$/
             else
               /^.*$/
             end
    errors.add(:room, "format is invalid #{channel}") unless channel =~ format
  end
end
