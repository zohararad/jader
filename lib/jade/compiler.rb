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

    def compile(template, file_name = '')
      template = template.read if template.respond_to?(:read)
      file_name.match(/views\/([^\/]+)\//)
      controller_name = $1 || nil
      combo = (template_helpers(controller_name) << template).join("\n").to_json
      tmpl = context.eval("jade.precompile(#{combo}, #{@options.to_json})")

      %{
        function(locals){
          #{tmpl}
        }
      }
    end

    def render(template, controller_name, vars = {})
      vars.each_pair do |k,v|
        vars[k] = v.attributes if v.respond_to? :attributes
      end
      combo = (template_helpers(controller_name) << template).join("\n").to_json
      tmpl = context.eval("jade.precompile(#{combo}, #{@options.to_json})")
      context.eval("function(locals){#{tmpl}}.call(null,#{vars.to_json})")
    end

    def template_helpers(controller_name)
      helpers = []
      unless Jade.configuration.mixins_path.nil?
        Dir["#{Jade.configuration.mixins_path}/*.jade"].each do |f|
          base_name = File.basename(f)
          if base_name == '%s_mixins.jade' % controller_name || base_name == 'application_mixins.jade'
            helpers << IO.read(f)
          end
        end
      end
      helpers
    end

  end
end