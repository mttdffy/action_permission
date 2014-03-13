require 'active_support/core_ext/object'
require 'active_support/dependencies'
require 'abstract_controller/helpers'

module ActionPermission

  module Controller
    extend ActiveSupport::Concern
    include AbstractController::Helpers

    included do
      delegate :allow?, to: :current_permission
      delegate :allow_param?, to: :current_permission
      delegate :allowed_params_for, to: :current_permission
      delegate :allow_param?, to: :current_permission
      helper_method :allow?
      helper_method :allow_param?
      helper_method :current_permission
    end

    module ClassMethods

      def authorize_with authorizer
        helper_method authorizer
        @@permission_authorizer = authorizer
      end

      def permission_authorizer
        @@permission_authorizer
      end

    end

    def current_resource
      nil
    end

    def current_permission
      @current_permission ||= ActionPermission::Dispatch.new(permission_authorizer)
    end

    def authorized?
      current_permission.allow?(params[:controller], params[:action], current_resource)
    end

    private

    def permission_authorizer
      send self.class.permission_authorizer
    end


  end

end

ActionController::Base.send :include, ActionPermission::Controller if ENV['RAILS']