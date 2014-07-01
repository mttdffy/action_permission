require 'rails/railtie'

module ActionPermission
  class Railtie < ::Rails::Railtie
    if config.respond_to?(:app_generators)
      config.app_generators.scaffold_controller = :action_permission_controller
    else
      config.generators.scaffold_controller = :action_permission_controller
    end
  end
end
