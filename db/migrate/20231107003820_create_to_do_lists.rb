class CreateToDoLists < ActiveRecord::Migration[7.0]
  def change
    create_table :to_do_lists do |t|
      t.string :title
      t.string :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
