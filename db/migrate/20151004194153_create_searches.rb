class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :query, null: false
      t.boolean :trend_or_location, null: false
      t.boolean :hidden, default: false, null: false
      t.belongs_to :user, null: false
    end
  end
end
