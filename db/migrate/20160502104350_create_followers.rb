class CreateFollowers < ActiveRecord::Migration
  def change
    create_table :followers do |t|
      t.string :uid
      t.string :followed_uid

      t.timestamps
    end
  end
end
