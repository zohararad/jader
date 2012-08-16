module Jade
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :mixins_path

    def initialize
      @mixins_path = nil
    end
  end
end