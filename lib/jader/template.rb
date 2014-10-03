require 'tilt/template'

module Jader
  # Jader Tilt template for use with JST
  class Template < Tilt::Template
    self.default_mime_type = 'application/javascript'

    def initializer
      super
    end

    # Ensure ExecJS is available when engine is initialized
    def self.engine_initialized?
      defined? ::ExecJS
    end

    # Require 'execjs' when initializing engine
    def initialize_engine
      require_template_library 'execjs'
    end

    def prepare
    end

    # Evaluate the template. Compiles the template for JST
    # @return [String] JST-compliant compiled version of the Jade template being rendered
    def evaluate(scope, locals, &block)
      Jader::Compiler.new(:filename => file).compile(data, file)
    end

  end
end
