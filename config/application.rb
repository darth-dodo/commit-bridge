require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"

# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
Dotenv::Railtie.load

module CommitBridge
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults(5.2)

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # https://github.com/cyu/rack-cors
    config.middleware.insert_before(0, Rack::Cors) do
      allow do
        origins ENV['CORS_ORIGINS'].split(',').map(&:strip)
        resource '*',
                 headers: :any,
                 methods: [:get, :post, :put, :patch, :delete, :options, :head]
      end
    end

    # api throttling using rack-attack
    config.middleware.use(Rack::Attack)

    # Middleware for ActiveAdmin
    config.middleware.use(Rack::MethodOverride)
    config.middleware.use(ActionDispatch::Flash)
    config.middleware.use(ActionDispatch::Cookies)
    config.middleware.use(ActionDispatch::Session::CookieStore)

    # sentry setup
    Raven.configure do |config|
      config.dsn = ENV['SENTRY_KEY']
    end
  end
end
