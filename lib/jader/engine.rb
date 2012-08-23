require 'sprockets'
require 'sprockets/engines'

module Jader
  class Engine < Rails::Engine
    initializer "jade.configure_rails_initialization", :before => 'sprockets.environment', :group => :all do |app|
      next unless app.config.assets.enabled
      Sprockets.register_engine '.jade', ::Jader::Template
    end
  end
end
