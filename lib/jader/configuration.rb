module Jader
  class << self
    attr_accessor :configuration
  end

  # Configure Jader
  # @yield [config] Jader::Configuration instance
  # @example
  #     Jader.configure do |config|
  #       config.mixins_path = Rails.root.join('app','assets','javascripts','helpers')
  #       config.includes << IO.read Rails.root.join('app','assets','javascripts','util.js')
  #     end
  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  # Jader configuration class
  class Configuration
    attr_accessor :mixins_path, :includes

    # Initialize Jader::Configuration class with default values
    def initialize
      @mixins_path = nil
      @includes = []
    end
  end
end