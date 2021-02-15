class CreatePermisiTables < ActiveRecord::Migration<%= migration_version %>
  def up
    create_table :permisi_actors do |t|
      t.references :aka, polymorphic: true
      t.timestamps
    end

    add_index :permisi_actors, [:aka_type, :aka_id]

    create_table :permisi_roles do |t|
      t.string :slug, null: false, unique: true
      t.string :name, null: false, unique: true
      t.json :permissions
      t.timestamps
    end

    create_table :permisi_actor_roles do |t|
      t.belongs_to :actor
      t.belongs_to :role
    end
  end

  def down
    drop_table :permisi_actor_roles
    drop_table :permisi_roles
    drop_table :permisi_actors
  end
end
