class CreateModLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :mod_logs do |t|
      t.string :action

      t.integer :user_id

      t.timestamps
    end

    change_table :mod_logs do |t|
      add_foreign_key :mod_logs, :users
    end
  end
end
