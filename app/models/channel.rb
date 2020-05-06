# frozen_string_literal: true

class Channel < ApplicationRecord
  belongs_to :platform
  belongs_to :member
  validates :platform, presence: true
  validates :channel, presence: true
  validate :validate_channel_format

  def validate_channel_format
    return unless platform.present?

    format = platform.platform == 'youtube' ? /^UC/ : /^\d+$/
    errors.add(:channel, 'format is invalid') unless channel =~ format
  end
end
