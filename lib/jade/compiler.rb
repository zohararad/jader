require 'execjs'

module Jade
  class Compiler
    attr_accessor :options

    def initialize(options={})
      @options = {
        :client => true,
        :compileDebug => false
      }.merge options
    end

    def source
      @source ||= %{
        var window = {};
        #{Jade::Source::jade}
        var jade = window.jade;
      }
    end

    def context
      @context ||= ExecJS.compile source
    end

    def jade_version
      context.eval("jade.version")
    end

    def compile(template)
      template = template.read if template.respond_to?(:read)
      template = context.eval("jade.precompile(#{template.to_json}, #{@options.to_json})")

      %{
        function(locals){
          #{template}
        }
      }
    end
  end
end