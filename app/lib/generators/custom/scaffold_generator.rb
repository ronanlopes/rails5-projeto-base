# lib/generators/custom/scaffold_generator.rb
require 'rails/generators/named_base'
require 'rails/generators/resource_helpers'
require 'rails/generators/named_base'

module Custom # :nodoc:
  module Generators # :nodoc:
    class Base < Rails::Generators::NamedBase #:nodoc:
      protected

      def format
        [:html, :slim]
      end

      def handler
        :erb
      end


      def filename_with_extensions(name, handl=nil)
        cformat = name[/\.js/] ? nil : format
        [name, cformat, handl].compact.join(".")
      end

    end

    class ScaffoldGenerator < Base # :nodoc:
      include Rails::Generators::ResourceHelpers

      source_root File.join(Rails.root, 'lib', 'templates', 'erb', 'scaffold', File::SEPARATOR)

      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

      def create_root_folder
        empty_directory File.join("app/views", controller_file_path)
      end

      def copy_view_files
        available_views.each do |view|
          template filename_with_extensions(view, :erb), File.join("app/views", controller_file_path, filename_with_extensions(view))
        end
        template "datatable.html.slim.erb", File.join("app/datatables", "#{controller_file_path}_datatable.rb") 
        template "datatable_js.html.slim.erb", File.join("app/assets/javascripts", "#{controller_file_path}.coffee") 
      end

    protected
      def available_views
        %w(index edit new _form)
      end
    end
  end
end