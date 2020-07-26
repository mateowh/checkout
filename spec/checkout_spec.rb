require 'checkout'

RSpec.describe Checkout do
  subject { described_class.new }

  # TODO: remove this
  it 'is a checkout' do
    expect(subject.is_a?(Checkout)).to be true
  end

  it 'initializes with promotional_rules'

  it 'initializes with an empty set of items' do
    expect(subject.items).to eq([])
  end

  describe 'scan' do
    let(:item) { 'something' }
    let(:co) { Checkout.new }
    subject { co.scan(item) }

    it 'adds items to the set of items' do
      expect{subject}.to change{co.items}.from([]).to(['something'])
    end

    it 'updates the total of the checkout'
  end

  describe 'total' do
    it 'sums prices for all items in the basket'

    it 'is updated when new items added'

    it 'applies discounts'
  end
end