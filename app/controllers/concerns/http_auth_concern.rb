# frozen_string_literal: true

module HttpAuthConcern
  extend ActiveSupport::Concern

  def authenticate
    return true unless Rails.env.production?

    authenticate_or_request_with_http_basic do |username, password|
      username == Rails.application.credentials[:http_basic][:username] &&
        password == Rails.application.credentials[:http_basic][:password]
    end
  end
end
