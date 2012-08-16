module Jade
  module Renderer

    def self.convert_template(template_text, vars = {})
      compiler = Jade::Compiler.new :client => false
      compiler.render(template_text, vars)
    end

    def self.call(template)
      template.source.gsub!(/\#\{([^\}]+)\}/,"\\\#{\\1}") # escape Jade's #{somevariable} syntax
      %{
        template_source = %{#{template.source}}
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
        Jade::Renderer.convert_template(template_source, variables.merge(local_assigns))
      }
    end

  end
end