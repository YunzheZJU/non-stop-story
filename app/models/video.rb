# frozen_string_literal: true

class Video < ApplicationRecord
  belongs_to :platform
  has_one :live
  validates :title, presence: true
  validates :duration, presence: true, numericality: {
    only_integer: true,
    greater_than: 0
  }
  validates :video, presence: true
  validate :validate_video_format

  def validate_video_format
    return unless platform.present?

    format = platform.platform == 'youtube' ? /^\w+$/ : /^(av\d+|bv\w+)$/i
    errors.add(:video, 'format is invalid') unless video =~ format
  end
end
