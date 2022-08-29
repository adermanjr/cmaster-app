require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CmasterApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # ******* !!!!!!!!!! *******
    I18n.available_locales = [:en, :'pt-BR']
    I18n.default_locale = :'pt-BR'
    
    config.time_zone = 'Brasilia'
    config.encoding = "utf-8"
    
    config.autoload_paths += %W(#{config.root}/lib)

    config.action_view.embed_authenticity_token_in_remote_forms = true
    
  end
end
