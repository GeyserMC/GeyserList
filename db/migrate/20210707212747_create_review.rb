class CreateReview < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.belongs_to :user
      t.text :description
      t.integer :rating
      t.belongs_to :server
      t.timestamps
    end
  end
end
