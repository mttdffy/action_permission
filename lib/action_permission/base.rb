module ActionPermission

  class Base

    class << self

      def match_with source,to
        Array(to).each do |role|
          alias_method role, source
        end
      end

    end

    attr_accessor :membership
    attr_reader :allowed_params, :allowed_actions

    def initialize(membership)
      load membership
    end

    def load(membership)
      @membership = membership
      role = @membership.identify
      if role && respond_to?(role)
        send(role)
      end
    end

    def allow?(action, resource = nil)
      allowed = @allowed_actions[action.to_s] if @allowed_actions
      allowed && (allowed == true || resource && allowed.call(resource))
    end

    def allow(actions, &block)
      @allowed_actions ||= {}
      Array(actions).each do |action|
        @allowed_actions[action.to_s] = block || true
      end
    end

    def allow_rest_actions(&block)
      allow [:index, :new, :create, :show, :edit, :update, :destroy], &block
    end

    def params
      []
    end

    def allow_params options=nil
      @allowed_params ||= []

      if options
        @allowed_params = allow_params_with_options options
      else
        @allowed_params = Array(params)
      end
    end

    private

    def allow_params_with_options options
      alt_params = params
      alt_params = Array(options[:only]) if options[:only]
      Array(options[:except]).each {|e| alt_params.delete e } if options[:except]
      alt_params
    end

  end

end