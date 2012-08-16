require 'jade/source'
require 'jade/compiler'
require 'jade/template'
require 'jade/renderer'
require 'jade/configuration'
require 'jade/engine' if defined?(::Rails)

ActionView::Template.register_template_handler :jade, Jade::Renderer
ActionView::Template.register_template_handler 'jst.jade', Jade::Renderer