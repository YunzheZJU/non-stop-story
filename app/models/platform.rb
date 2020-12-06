# frozen_string_literal: true

class Platform < ApplicationRecord
  has_many :channels
  has_many :rooms
  has_many :videos
  validates :platform, inclusion: { in: %w[youtube bilibili twitch] }
end
