module Jader
  class << self
    attr_accessor :configuration
  end

  # Configure Jader
  # @yield [config] Jader::Configuration instance
  # @example
  #     Jader.configure do |config|
  #       config.mixins_path = Rails.root.join('app','assets','javascripts','mixins')
  #       config.views_path = Rails.root.join('app','assets','javascripts','views')
  #       config.includes << IO.read Rails.root.join('app','assets','javascripts','util.js')
  #     end
  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  # Jader configuration class
  class Configuration
    attr_accessor :mixins_path, :views_path, :includes, :prepend_view_path

    # Initialize Jader::Configuration class with default values
    def initialize
      @mixins_path = nil
      @views_path = nil
      @includes = []
      @prepend_view_path = false
    end
  end
end