RSpec.describe Recommendation, type: :model do
  describe Recommendation do
    it { should validate_presence_of(:query) }
    it { should validate_presence_of(:trend_or_location) }
    it { should validate_presence_of(:category) }
    it { should belong_to(:user) }
  end
end
