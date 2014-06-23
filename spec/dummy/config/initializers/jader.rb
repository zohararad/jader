Jader.configure do |config|
  config.mixins_path = Rails.root.join('app','assets','javascripts','mixins')
  config.views_path = Rails.root.join('app','assets','javascripts','views')
  config.includes << IO.read(Rails.root.join('app','assets','javascripts','includes','util.js'))
  config.prepend_view_path = true
end