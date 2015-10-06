RSpec.describe Search, type: :model do
  describe Search do
    it { should validate_presence_of(:query) }
    it { should validate_presence_of(:trend_or_location) }
    it { should belong_to(:user) }
  end
end
