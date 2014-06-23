require 'sprockets'
require 'sprockets/engines'

module Jader
  class Engine < Rails::Engine
    initializer "jade.configure_rails_initialization", :before => 'sprockets.environment', :group => :all do |app|
      sprockets_env = app.assets || Sprockets
      sprockets_env.register_engine '.jade', ::Jader::Template
    end

    initializer 'jader.prepend_views_path', :after => :add_view_paths do |app|
      next if Jader::configuration.nil? or Jader::configuration.views_path.nil?
      app.config.paths['app/views'].unshift(Jader::configuration.views_path)
    end

  end
end
