# frozen_string_literal: true

class Channel < ApplicationRecord
  has_many :lives
  belongs_to :platform
  belongs_to :member, optional: true
  belongs_to :editor, optional: true
  validate :validate_channel_format

  def validate_channel_format
    return unless platform.present?

    format = platform.platform == 'youtube' ? /^UC[\w-]+$/ : /^\d+$/
    errors.add(:channel, "format is invalid #{channel}") unless channel =~ format
  end
end
