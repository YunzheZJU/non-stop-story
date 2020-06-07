# frozen_string_literal: true

require 'test_helper'

class DailySummaryMailerTest < ActionMailer::TestCase
  test 'should send air email' do
    config = Rails.configuration.email[:daily_summary]
    email = DailySummaryMailer.email
    assert_emails 1 do
      email.deliver_now
    end
    assert_equal [config[:from]], email.from
    assert_equal [config[:to]], email.to
    assert_equal "[Non Stop Story/Daily Summary] #{Date.today - 1.day}",
                 email.subject
  end
end
