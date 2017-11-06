class CreateClients < ActiveRecord::Migration[5.1]
  def change
    create_table :clients do |t|
      t.timestamps
      t.string :name, null: false
      t.string :subdomain
      t.json :settings, default: {}
    end
  end
end
