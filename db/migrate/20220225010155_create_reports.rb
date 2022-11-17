class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      # Report info
      t.string :name
      t.string :description
      t.string :status # open, closed, etc.
      t.string :resolution # "Nah", "Etc".
      t.string :source # "comment", "server", "user", etc.
      t.integer :source_id # ID of the source.

      t.integer :user_id # ID of the user who created the report.

      # Timestamps
      t.timestamps
    end

    change_table :reports do |t|
      add_foreign_key :reports, :users
    end
  end
end
