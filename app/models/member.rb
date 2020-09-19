# frozen_string_literal: true

class Member < ApplicationRecord
  has_many :channels
  validates :name, presence: true
  validates_each :color_main, :color_sub do |record, attr, value|
    next unless value.present?
    next if value =~ /^#[0-9a-fA-F]+$/

    record.errors.add(attr, "only allows hex colors start with '#'")
  end

  scope :active, -> { where(graduated: false) }
end
