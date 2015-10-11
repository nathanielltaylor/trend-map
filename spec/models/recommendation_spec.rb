RSpec.describe Recommendation, type: :model do
  describe Recommendation do
    it { should validate_presence_of(:query) }
    it { should validate_presence_of(:trend_or_location) }
    it { should validate_presence_of(:category) }
    it { should belong_to(:user) }
  end

  it "can be searched for with multiple parameters" do
    boston = FactoryGirl.create(:recommendation)
    la = FactoryGirl.create(
      :recommendation,
      query: "Los Angeles",
      category: "Sports and Entertainment"
    )
    cats = FactoryGirl.create(
      :recommendation,
      query: "cats",
      trend_or_location: "Trend",
      category: "Sports and Entertainment"
    )
    debate = FactoryGirl.create(
      :recommendation,
      query: "presidential debate",
      trend_or_location: "Trend",
      category: "Politics and Religion"
    )
    expect(Recommendation.search("boston", nil, nil)) == [boston]
    expect(Recommendation.search(nil, "Trend", nil)) == [cats, debate]
    expect(Recommendation.search(nil, nil, "Sports and Entertainment")) == [la, cats]
    expect(Recommendation.search(nil, "Trend", "Politics and Religion")) == [debate]
  end
end
