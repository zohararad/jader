module Jader
  module Renderer

    def self.convert_template(template_text, controller_name, vars = {})
      compiler = Jader::Compiler.new :client => true
      compiler.render(template_text, controller_name, vars)
    end

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