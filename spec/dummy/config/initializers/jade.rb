Jade.configure do |config|
  config.mixins_path = Rails.root.join('app','assets','javascripts','mixins')
  config.includes << IO.read(Rails.root.join('app','assets','javascripts','includes','util.js'))
end