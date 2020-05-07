# frozen_string_literal: true

class Editor < ApplicationRecord
  validates :name, presence: true
end
