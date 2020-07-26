require 'items/personalised_cufflinks'

RSpec.describe PersonalisedCufflinks do
  subject { PersonalisedCufflinks.new }

  describe '.price' do
    it 'returns the base price' do
      expect(subject.price).to eq(45)
    end
  end
end
