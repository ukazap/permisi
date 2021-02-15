require "rails/generators"
require "rails/generators/migration"
require "rails/generators/active_record"

module Permisi
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)

      def self.next_migration_number(path)
        ActiveRecord::Generators::Base.next_migration_number(path)
      end

      def create_initializer
        template 'initializer.rb', 'config/initializers/permisi.rb'
      end

      def create_migrations
        migration_template 'migration.rb', 'db/migrate/create_permisi_tables.rb', migration_version: migration_version
      end

      private

      def migration_version
        if ActiveRecord.version.version > '5'
          "[#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}]"
        end
      end
    end
  end
end
