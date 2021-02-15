require "active_record"

class CreateTestTables < ActiveRecord::Migration[6.1]
  def change
    create_table :permisi_actors
    create_table :permisi_roles do |t|
      t.json :permissions
    end
    create_table :permisi_actor_roles
  end
end
