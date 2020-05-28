# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/daily_summary_mailer
class DailySummaryMailerPreview < ActionMailer::Preview
  def email
    DailySummaryMailer.email
  end
end
