module Jader
  module Source
    def self.jade
      IO.read jade_path
    end

    def self.runtime
      IO.read runtime_path
    end

    def self.jade_path
      File.expand_path("../../../vendor/assets/javascripts/jade/jade.js", __FILE__)
    end

    def self.runtime_path
      File.expand_path("../../../vendor/assets/javascripts/jade/runtime.js", __FILE__)
    end
  end
end