class FixTrendOrLocation < ActiveRecord::Migration
  def change
    change_column(:searches, :trend_or_location, :string)
    change_column(:recommendations, :trend_or_location, :string)
  end
end
