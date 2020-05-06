# frozen_string_literal: true

class Platform < ApplicationRecord
  has_many :channels, inverse_of: :platform
  has_many :rooms, inverse_of: :platform
  has_many :videos, inverse_of: :platform
  validates :platform, inclusion: { in: %w[youtube bilibili] }
end
