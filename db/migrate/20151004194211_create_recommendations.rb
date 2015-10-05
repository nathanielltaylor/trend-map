class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.string :query, null: false
      t.boolean :trend_or_location, null: false
      t.string :category, null: false
      t.string :description
      t.belongs_to :user, null: false
    end
  end
end
