module Doormat
  class Rails < ::Rails::Engine
    config.autoload_paths << File.expand_path("#{config.root}/app/mats") if File.exist?("#{config.root}/app/mats")
  end if defined?(::Rails)
end
