require 'rails/railtie'

module ActionPermission
  class Railtie < ::Rails::Railtie
    if config.respond_to?(:app_generators)
      config.app_generators.scaffold_controller = :action_permission_controller
    else
      config.generators.scaffold_controller = :action_permission_controller
    end

    # initializer 'activeservice.autoload', :before => :set_autoload_paths do |app|
    #   app.config.autoload_paths << (app.config.root + '/app/permissions')
    # end

    # initializer "strong_parameters.config", :before => "action_controller.set_configs" do |app|
    #   ActionController::Parameters.action_on_unpermitted_parameters = app.config.action_controller.delete(:action_on_unpermitted_parameters) do
    #     (Rails.env.test? || Rails.env.development?) ? :log : false
    #   end
    # end
  end
end