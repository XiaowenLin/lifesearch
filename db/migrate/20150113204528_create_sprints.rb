class CreateSprints < ActiveRecord::Migration
  def up
    create_table :sprints do |t|
      t.integer         'parent'
      t.date            'start'
      t.date            'end'
      t.integer         'hours'
      t.text            'name'
      t.text            'desc'
      t.integer         'happy'
      t.timestamps
    end
  end
  def down
    drop_table :sprints
  end
end
