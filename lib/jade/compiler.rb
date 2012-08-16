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

    def render(template, vars = {})
      vars.each_pair do |k,v|
        vars[k] = v.attributes if v.respond_to? :attributes
      end
      combo = (helpers << template).join("\n").to_json
      tmpl = context.eval("jade.precompile(#{combo}, #{@options.to_json})")
      context.eval("function(locals){#{tmpl}}.call(null,#{vars.to_json})")
    end

    def helpers
      helpers = []
      unless Jade.configuration.mixins_path.nil?
        Dir["#{Jade.configuration.mixins_path}/*.jade"].each do |f|
          helpers << IO.read(f)
        end
      end
      helpers
    end

  end
end