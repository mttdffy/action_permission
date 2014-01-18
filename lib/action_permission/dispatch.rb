module ActionPermission

  class Dispatch
    attr_accessor :membership, :permissions
    
    def initialize(membership)
      @membership = membership
      @permissions = {}.with_indifferent_access
    end

    def allow?(controller, action, resource = nil)
      current_permission = load_permission controller

      if resource
        current_permission.allow?(action, resource)
      else !resource
        current_permission.allow?(action)
      end
    end

    def allowed_params_for(resource, params)
      resource = resource.to_s
      current_permission = load_permission resource.pluralize
      if current_permission && current_permission.allowed_params
        params.require(resource).permit *current_permission.allowed_params
      end
    end

    def allow_param?(resource, attribute)
      current_permission = load_permission resource.to_s.pluralize

      if current_permission && current_permission.allowed_params
        current_permission.allowed_params.include? attribute
      else
        false
      end
    end

    private

      def load_permission(controller)
        klass = get_class_name(controller)
        # grab the permissions for this controller from cache or register it if missing
        @permissions[controller] ||= register_permission(controller, klass)
      end

      def get_class_name(controller)
        controller = controller.to_s
        return (controller.pluralize + "_permissions").classify.constantize
      end

      def register_permission(controller, klass)
        @permissions[controller] = klass.new(@membership)
      end

  end

end