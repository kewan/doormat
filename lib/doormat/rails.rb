module Doormat
  class Rails < ::Rails::Engine
    config.autoload_paths << File.expand_path("#{config.root}/app/formatters") if File.exist?("#{config.root}/app/formatters")
  end if defined?(::Rails)
end
