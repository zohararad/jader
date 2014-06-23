require 'sprockets'
require 'sprockets/engines'

module Jader
  class Engine < Rails::Engine
    initializer "jade.configure_rails_initialization", :before => 'sprockets.environment', :group => :all do |app|
      app.assets.register_engine '.jade', ::Jader::Template
    end

    initializer 'jader.prepend_views_path', :after => :add_view_paths do |app|
      next if Jader::configuration.nil? or Jader::configuration.views_path.nil?
      ActionController::Base.class_eval do
        before_filter do |controller|
          prepend_view_path Jader::configuration.views_path
        end
      end
    end

  end
end
