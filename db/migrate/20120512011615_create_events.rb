class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :fbeventid

      t.timestamps
    end
  end
end
