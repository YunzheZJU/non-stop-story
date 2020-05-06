# frozen_string_literal: true

class Member < ApplicationRecord
  has_many :channels, inverse_of: :member
  has_many :lives, inverse_of: :member
  validates :name, presence: true
end
