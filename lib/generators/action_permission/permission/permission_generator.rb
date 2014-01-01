require 'rails/generators/named_base'

module ActionPermission
  module Generators
    class PermissionGenerator < Rails::Generators::NamedBase
      argument :attributes, type: :array, default: [], banner: "field field"
      source_root File.expand_path("../templates", __FILE__)

      def create_permission_file
        template "permission.rb", "app/permissions/#{file_name}_permission.rb"
      end
    end
  end
end