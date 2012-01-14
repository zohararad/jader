require 'sprockets'

module Jade
  class Engine < Rails::Engine
    initializer "jade.configure_rails_initialization", :before => 'sprockets.environment', :group => :all do |app|
      next unless app.config.assets.enabled
      Sprockets.register_engine '.jade', ::Jade::Template
    end
  end
end