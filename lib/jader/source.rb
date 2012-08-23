module Jader
  # Jade template engine Javascript source code
  module Source

    # Jade source code
    def self.jade
      IO.read jade_path
    end

    # Jade runtime source code
    def self.runtime
      IO.read runtime_path
    end

    # Jade source code path
    def self.jade_path
      File.expand_path("../../../vendor/assets/javascripts/jade/jade.js", __FILE__)
    end

    # Jade runtime source code path
    def self.runtime_path
      File.expand_path("../../../vendor/assets/javascripts/jade/runtime.js", __FILE__)
    end
  end
end