require 'items/kids_tshirt'

RSpec.describe KidsTshirt do
  subject { KidsTshirt.new }

  describe '.price' do
    it 'returns the base price' do
      expect(subject.price).to eq(19.95)
    end
  end
end
