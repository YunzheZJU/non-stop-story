# frozen_string_literal: true

class DailySummaryMailer < ApplicationMailer
  before_action :data

  def email
    @config = Rails.configuration.email[:daily_summary]
    mail(from: @config[:from],
         to: @config[:to],
         subject: "[Non Stop Story/Daily Summary] #{Date.today - 1.day}")
  end

  private

  def data
    @end = Time.current.midnight
    @start = @end - 1.day
    lives = Live.where(start_at: @start..@end)
    @count = lives.count
    @duration = lives.sum(:duration)
  end
end
