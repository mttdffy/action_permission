require 'rails/generators/named_base'

module ActionPermission
  module Generators

    class PermissionGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("../templates", __FILE__)

      def copy_permission_file
        copy_file "permission.rb", "app/permissions/#{file_name}_permission.rb"
      end
    end

  end
end