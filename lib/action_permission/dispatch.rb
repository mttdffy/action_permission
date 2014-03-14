require 'active_support/hash_with_indifferent_access'
require 'active_support/inflector'

module ActionPermission

  class Dispatch
    attr_accessor :membership, :permissions

    def initialize(membership)
      @membership = membership
      @permissions = HashWithIndifferentAccess.new
    end

    def allow?(controller, action, resource = nil)
      current_permission = load_permission controller

      if resource
        current_permission.allow?(action, resource)
      else !resource
        current_permission.allow?(action)
      end
    end

    # 'book/review', params #=> controller == 'books/reviews'
    # 'book/review', params, 'reviews' #=> controller == 'reviews'
    def allowed_params_for(resource, params, controller=nil)
      controller  = set_controller(resource, controller)
      resource    = set_resource(resource)

      current_permission = load_permission(controller)

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

      def set_controller(resource, controller)
        if controller
          case controller
          when String, Symbol
            controller.to_s.pluralize
          else
            (controller.is_a?(Class) ? controller : controller.class).
              name.underscore.gsub('_controller', '')
          end
        else
          case resource
          when String, Symbol
            resource.to_s
          else
            (resource.is_a?(Class) ? resource : resource.class).
              name.underscore
          end.
          split('/').map(&:pluralize).join('/')
        end
      end

      def set_resource(resource)
        case resource
        when String, Symbol
          resource.to_s.parameterize("_")
        else
          (resource.is_a?(Class) ? resource : resource.class).model_name.param_key
        end
      end

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