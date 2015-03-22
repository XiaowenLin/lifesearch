class AddUserIdToSprints < ActiveRecord::Migration
  def change
    add_column :sprints, :user_id, :int
  end
end
