# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  Rails.application.credentials.http_basic!
end
