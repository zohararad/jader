require 'execjs'

module Jader
  class Compiler
    attr_accessor :options

    # Initialize Jader template compiler. @see https://github.com/visionmedia/jade#options
    # @param [Hash] options Jade compiler options
    # @option options [Boolean] :client run Jade compiler in client / server mode (default `true`)
    # @option options [Boolean] :compileDebug run Jade compiler in debug mode(default `false`)
    def initialize(options={})
      @options = {
        :client => true,
        :compileDebug => false
      }.merge options
    end

    # Jade template engine Javascript source code used to compile templates in ExecJS
    # @return [String] Jade source code
    def source
      @source ||= %{
        var window = {};
        #{Jader::Source::jade}
        var jade = window.jade;
      }
    end

    # ExecJS context with Jade code compiled
    # @return [ExecJS::Context] compiled Jade source code context
    def context
      @context ||= ExecJS.compile source
    end

    # ExecJS context for the server-side rendering with Jade code compiled
    # @return [ExecJS::Context] compiled Jade source code context for the server-side rendering
    def server_context
      @server_context ||= ExecJS.compile([
        source,
        Jader.configuration.includes.join("\n")
      ].join(" "))
    end

    # Jade Javascript engine version
    # @return [String] version of Jade javascript engine installed in `vendor/assets/javascripts`
    def jade_version
      context.eval("jade.version")
    end

    # Compile a Jade template for client-side use with JST
    # @param [String, File] template Jade template file or text to compile
    # @param [String] file_name name of template file used to resolve mixins inclusion
    # @return [String] Jade template compiled into Javascript and wrapped inside an anonymous function for JST
    def compile(template, file_name = '')
      template = template.read if template.respond_to?(:read)
      file_name.match(/views\/([^\/]+)\//)
      controller_name = $1 || nil
      context.eval("jade.compile(#{combo(controller_name, template)},#{@options.to_json}).toString()").to_s.sub('function anonymous','function')
    end

    # Compile and evaluate a Jade template for server-side rendering
    # @param [String] template Jade template text to render
    # @param [String] controller_name name of Rails controller that's rendering the template
    # @param [Hash] vars controller instance variables passed to the template
    # @return [String] HTML output of compiled Jade template
    def render(template, controller_name, vars = {})
      server_context.exec("return jade.compile(#{combo(controller_name, template)})(#{vars.to_jade.to_json})")
    end

    # Jade template mixins for a given controller
    # @param [String] controller_name name of Rails controller rendering a Jade template
    # @return [Array<String>] array of Jade mixins to use with a Jade template rendered by a Rails controller
    def template_mixins(controller_name)
      mixins = []
      unless Jader.configuration.mixins_path.nil?
        Dir["#{Jader.configuration.mixins_path}/*.jade"].each do |f|
          base_name = File.basename(f)
          if base_name == '%s_mixins.jade' % controller_name || base_name == 'application_mixins.jade'
            mixins << IO.read(f)
          end
        end
      end
      mixins
    end

    def combo(controller_name, template)
      (template_mixins(controller_name) << template).join("\n").to_json
    end

  end
end