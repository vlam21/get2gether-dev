class CreateUserEvents < ActiveRecord::Migration
  def change
    create_table :user_events do |t|
      t.integer :fbid
      t.integer :fbeventid

      t.timestamps
    end
  end
end
