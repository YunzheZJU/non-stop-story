# frozen_string_literal: true

class Room < ApplicationRecord
  belongs_to :platform
  has_many :lives
  validates :platform, presence: true
  validates :room, presence: true
  validate :validate_room_format

  def validate_room_format
    return unless platform.present?

    format = platform.platform == 'youtube' ? /^\w+$/ : /^\d+$/
    errors.add(:room, 'format is invalid') unless room =~ format
  end
end
