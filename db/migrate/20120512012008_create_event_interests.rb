class CreateEventInterests < ActiveRecord::Migration
  def change
    create_table :event_interests do |t|
      t.integer :fbeventid
      t.integer :interestid

      t.timestamps
    end
  end
end
