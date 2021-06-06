# frozen_string_literal: true

class Clip < ApplicationRecord
  belongs_to :live
  has_and_belongs_to_many :arranges
  validates :in_time, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
  }
  validates :out_time, presence: true, numericality: {
    only_integer: true,
    greater_than: 0,
  }
  validate :in_time_is_less_than_out_time
  validate :out_time_is_less_than_duration

  def in_time_is_less_than_out_time
    errors.add(:in, 'cannot be larger than out') unless in_time <= out_time
  end

  def out_time_is_less_than_duration
    return errors.add(:live, 'should have duration') unless defined? live.video.duration

    return if out_time <= live.video.duration

    errors.add(:out, 'cannot be larger than duration')
  end
end
