ActiveAdmin.setup do |config|
  config.comments_input = :rich_text_area
  config.components = YAML.load_file(Rails.root.join("config/adminterface/components.yml").to_s)
  config.css_classes = YAML.load_file(Rails.root.join("config/adminterface/css_classes.yml").to_s)
end
