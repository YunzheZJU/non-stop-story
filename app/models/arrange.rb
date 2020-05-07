# frozen_string_literal: true

class Arrange < ApplicationRecord
  belongs_to :video
  has_and_belongs_to_many :clips
  has_and_belongs_to_many :editors
end
