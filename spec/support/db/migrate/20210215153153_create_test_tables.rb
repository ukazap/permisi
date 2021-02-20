# frozen_string_literal: true

require "active_record"

class CreateTestTables < ActiveRecord::Migration[6.1]
  def change
    create_table :permisi_actors do |t|
      t.references :aka, polymorphic: true
      t.timestamps
    end

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

    create_table :users do |t|
      t.timestamps
      t.string :name
    end
  end
end
