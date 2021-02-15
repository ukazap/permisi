# frozen_string_literal: true

# require "byebug"
require "simplecov"
require "active_record"

SimpleCov.start do
  add_filter '/spec/'
end

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

db_config = {"adapter" => "sqlite3", "database" => "spec/support/db/test.db"}

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    ActiveRecord::Base.establish_connection(db_config)
    ActiveRecord::MigrationContext.new("spec/support/db/migrate/", ActiveRecord::SchemaMigration).migrate
  end

  config.after(:suite) do
    File.delete(db_config["database"]) if File.exist?(db_config["database"])
  end
end

require "permisi"
$permisi_loader.eager_load
