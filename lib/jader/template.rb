require 'tilt/template'

module Jader
  class Template < Tilt::Template
    self.default_mime_type = 'application/javascript'

    def self.engine_initialized?
      defined? ::ExecJS
    end

    def initialize_engine
      require_template_library 'execjs'
    end

    def prepare
    end

    def evaluate(scope, locals, &block)
      compile_function
    end

  private

    def compile_function
      Jader::Compiler.new(:filename => file).compile(data, file)
    end

  end
end
