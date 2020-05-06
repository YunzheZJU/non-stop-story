# frozen_string_literal: true

class Member < ApplicationRecord
  has_many :channels
  has_many :lives
  validates :name, presence: true
end
