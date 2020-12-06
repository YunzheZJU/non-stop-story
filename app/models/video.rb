# frozen_string_literal: true

class Video < ApplicationRecord
  belongs_to :platform
  has_one :live
  has_one :arrange
  validates :title, presence: true
  validates :duration, presence: true, numericality: {
    only_integer: true,
    greater_than: 0
  }
  validates :video, presence: true
  validate :validate_video_format

  def validate_video_format
    return unless platform.present?

    format = case platform.platform
             when 'youtube'
               /^\w+$/
             when 'bilibili'
               /^(av\d+|bv\w+)$/i
             when 'twitch'
               /^\d+$/
             else
               /^.*$/
             end
    errors.add(:video, 'format is invalid') unless video =~ format
  end
end
