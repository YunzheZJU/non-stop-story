# frozen_string_literal: true

class Member < ApplicationRecord
  has_many :channels
  validates :name, presence: true
end
