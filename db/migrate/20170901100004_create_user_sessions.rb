class CreateUserSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :user_sessions do |t|
      t.timestamps
      t.references :user, null: false
      t.string :access_token, null: false, length: 128
      t.string :user_agent
      t.string :ip_address
      t.datetime :accessed_at
      t.datetime :revoked_at
    end
  end
end
