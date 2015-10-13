class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :text, null: false
      t.decimal :latitude, null: false
      t.decimal :longitude, null: false

      t.timestamps
    end
  end
end
