class CreateBookings < ActiveRecord::Migration[5.1]
  def change
    create_table :bookings do |t|
      t.timestamps

      t.references :user
      t.references :rental
      t.references :client, null: false
      t.date :start_at, null: false
      t.date :end_at, null: false
      t.integer :days, null: false
      t.float :daily_rate, null: false
      t.float :price, null: false
    end
  end
end
