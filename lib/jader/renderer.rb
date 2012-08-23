module Jader
  # Server side Jade templates renderer
  module Renderer

    # Convert Jade template to HTML output for rendering as a Rails view
    # @param [String] template_text Jade template text to convert
    # @param [String] controller_name name of Rails controller rendering the view
    # @param [Hash] vars controller instance variables passed to the template
    # @return [String] HTML output of evaluated template
    # @see Jader::Compiler#render
    def self.convert_template(template_text, controller_name, vars = {})
      compiler = Jader::Compiler.new :client => true
      compiler.render(template_text, controller_name, vars)
    end

    # Prepare controller instance variables for the template and execute template conversion.
    # Called as an ActionView::Template registered template
    # @param [ActionView::Template] template currently rendered ActionView::Template instance
    # @see Jader::Renderer#convert_template
    def self.call(template)
      template.source.gsub!(/\#\{([^\}]+)\}/,"\\\#{\\1}") # escape Jade's #{somevariable} syntax
      %{
        template_source = %{#{template.source}}
        controller_name = controller.controller_name
        variable_names = controller.instance_variable_names
        variable_names -= %w[@template]
        if controller.respond_to?(:protected_instance_variables)
          variable_names -= controller.protected_instance_variables
        end

        variables = {}
        variable_names.each do |name|
          next if name.include? '@_'
          variables[name.sub(/^@/, "")] = controller.instance_variable_get(name)
        end
        Jader::Renderer.convert_template(template_source, controller_name, variables.merge(local_assigns))
      }
    end

  end
end