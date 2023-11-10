class AddTagRefToTasks < ActiveRecord::Migration[7.0]
  def change
    add_reference(:tasks, :tag, null: false, foreign_key: true)
  end
end
