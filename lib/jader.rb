require 'jader/source'
require 'jader/compiler'
require 'jader/template'
require 'jader/renderer'
require 'jader/configuration'
require 'jader/serialize'
require 'jader/engine' if defined?(::Rails)

ActionView::Template.register_template_handler :jade, Jader::Renderer
ActionView::Template.register_template_handler 'jst.jade', Jader::Renderer

Jader.configure do |config|; end