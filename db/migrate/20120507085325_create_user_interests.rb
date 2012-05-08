class CreateUserInterests < ActiveRecord::Migration
  def change
    create_table :user_interests do |t|
      t.integer :fbid
      t.integer :interestid

      t.timestamps
    end
  end
end
