# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NonStopStory
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # config.log_level = :warn if Rails.env.production?

    config.action_dispatch.default_headers = {
      'X-Frame-Options' => 'SAMEORIGIN',
      'X-XSS-Protection' => '1; mode=block',
      'X-Content-Type-Options' => 'nosniff',
      'X-Download-Options' => 'noopen',
      'X-Permitted-Cross-Domain-Policies' => 'none',
      'X-Powered-By' => 'Non Stop Story - KARKINOS v1.0',
      'Referrer-Policy' => 'strict-origin-when-cross-origin'
    }

    config.active_job.queue_name_prefix = Rails.env
    config.active_job.queue_name_delimiter = '.'

    config.worker = config_for(:worker)
    config.email = config_for(:email)
    config.after_initialize do
      # Ugly fix for duplicated jobs when multiple workers are running
      # Leave exactly ONE worker executing jobs and pass ENV['disable-job'] = 'true' to the others
      unless ENV['DISABLE_JOB'] == 'true'
        LivesDetectJob.set(wait: 5.seconds).perform_later

        if Rails.env.production?
          DailySummaryJob.set(wait_until: Time.now.midnight + 8.hours)
                         .perform_later
        else
          DailySummaryJob.set(wait: 5.seconds).perform_later
        end
      end
    end
  end
end
