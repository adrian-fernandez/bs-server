class CreateRentals < ActiveRecord::Migration[5.1]
  def change
    create_table :rentals do |t|
      t.timestamps

      t.string :name, null: false
      t.references :client, null: false
      t.float :daily_rate
      t.references :user
    end
  end
end
