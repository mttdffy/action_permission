require 'rails/generators/base'

module ActionPermission
  module Generators

    class InstallGenerator < Rails::Generators::Base
      p "creating permissions directory"
      source_root File.expand_path("../templates", __FILE__)

      def copy_init_file
        copy_file "init.rb", "app/permissions/application_permission.rb"
      end
      
      def add_controller_setup
        line = "class ApplicationController < ActionController::Base"
        inject_into_file 'app/controllers/application_controller.rb', after: "#{line}\n" do <<-'RUBY'
          authorize_with :current_user
          before_action :check_permission
          
          def current_user
            @current_user ||= session[:user_id] ? User.find(session[:user_id]) : User.new
          end
          
          def check_permission
            unless authorized?
              #do something when user does not have permission to access page
              # Flash[:warn] = "You do not have permission to access this page."
              # redirect_to root_url
            end
          end
        RUBY
        end
      end
    end

  end
end