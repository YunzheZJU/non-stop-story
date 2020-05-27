# frozen_string_literal: true

class DailySummaryJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    DailySummaryMailer.email.deliver_now
  rescue StandardError => e
    Logger.error e
  ensure
    DailySummaryJob.set(wait_until: Time.now.midnight + 1.day + 8.hours)
                   .perform_later
  end
end
