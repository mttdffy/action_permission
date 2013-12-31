module ActionPermission

  module Controller

    def self.included(base)
      base.extend ClassMethods
      base.delegate :allow?, to: :current_permission
      base.delegate :allow_param?, to: :current_permission
      base.delegate :allowed_params_for, to: :current_permission
      base.delegate :allow_param?, to: :current_permission
      base.helper_method :allow?
      base.helper_method :allow_param?
      base.helper_method :current_permission
    end

    def current_resource
      logger.warn "WARNING: #{self.class} has not yet implemented #current_resource"
      nil
    end

    def current_permission
      @current_permission ||= ActionPermission::Dispatch.new(permission_authorizer)
    end

    private

      def permission_authorizer
        send self.class.permission_authorizer
      end

      def authorized?
        current_permission.allow?(params[:controller], params[:action], current_resource)
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

  end

end

ActionController::Base.send :include, ActionPermission::Controller