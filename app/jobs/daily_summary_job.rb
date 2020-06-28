# frozen_string_literal: true

class DailySummaryJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    DailySummaryMailer.email.deliver_now
  rescue StandardError => e
    logger.error e.message
  ensure
    DailySummaryJob.set(wait_until: Time.current.tomorrow.midnight)
                   .perform_later
  end
end
