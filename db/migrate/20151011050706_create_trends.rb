class CreateTrends < ActiveRecord::Migration
  def change
    create_table :trends do |t|
      t.string :name, null: false
      t.decimal :latitude, null: false
      t.decimal :longitude, null: false

      t.timestamps
    end
  end
end
