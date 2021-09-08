require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AdminterfaceDemo
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Turn off these assets on scaffold
    config.generators do |g|
      g.javascripts false
      g.stylesheets false
      g.helper false
      g.test_framework :rspec, fixture: false
      g.view_specs false
      g.helper_specs false
    end

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.i18n.fallbacks = %i[en]
    config.i18n.default_locale = :en
  end
end
