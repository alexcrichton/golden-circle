require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require :default, Rails.env

module GoldenCircle
  class Application < Rails::Application
    config.filter_parameters += [:password, :password_confirmation]
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Add additional load paths for your own custom dirs
    # config.load_paths += %W( #{config.root}/extras )

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
    # config.i18n.default_locale = :de

    # Configure generators values. Many other options are available, be sure to check the documentation.
    # config.generators do |g|
    #   g.orm             :active_record
    #   g.template_engine :erb
    #   g.test_framework  :test_unit, :fixture => true
    # end
    # require 'acts_as_slug'
    # # require 'smtp_tls' if RUBY_VERSION < '1.8.7'
    # ActiveRecord::Base.class_eval do
    #   include Acts::Slug
    # 
    #   def to_xml(options = {})
    #     # protect attributes registered with attr_protected
    #     default_except = self.class.protected_attributes.to_a
    #     options[:except] = (options[:except] ? options[:except] | default_except : default_except)
    #     super
    #   end
    # end
    # ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(:default => '%l:%M%p %m/%d/%Y')

  end
end
