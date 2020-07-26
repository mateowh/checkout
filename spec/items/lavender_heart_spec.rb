require 'items/lavender_heart'

RSpec.describe LavenderHeart do
  subject { LavenderHeart.new }

  describe '.price' do
    it 'returns the base price' do
      expect(subject.price).to eq(9.25)
    end
  end
end
