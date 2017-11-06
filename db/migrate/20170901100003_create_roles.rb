class CreateRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :roles do |t|
      t.timestamps null: false
      t.string :name, null: false
      t.references :client, null: false
      t.json :permissions, default: {}
    end

    add_index :roles, :name
  end

  create_table :user_roles do |t|
    t.timestamps null: false
    t.references :client, null: false
    t.references :user, null: false
    t.references :role, null: false
  end
end
