# frozen_string_literal: true

class Live < ApplicationRecord
  belongs_to :member
  belongs_to :room
  validates :title, presence: true
  validates :start_at, presence: true
  validates :room, presence: true
  validates :member, presence: true
end
