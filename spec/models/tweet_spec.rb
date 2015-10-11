RSpec.describe Tweet, type: :model do
  describe Tweet do
    it { should validate_presence_of(:text) }
    it { should validate_presence_of(:latitude) }
    it { should validate_numericality_of(:latitude) }
    it { should validate_presence_of(:longitude) }
    it { should validate_numericality_of(:longitude) }
  end
end
