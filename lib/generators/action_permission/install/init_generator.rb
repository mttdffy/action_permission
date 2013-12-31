require 'rails/generators/base'

module ActionPermission
  module Generators

    class InitGenerator < Rails::Generators::Base
      p "creating permissions directory"
      source_root File.expand_path("../templates", __FILE__)

      def copy_init_file
        copy_file "init.rb", "app/permissions/application_permission.rb"
      end
    end

  end
end