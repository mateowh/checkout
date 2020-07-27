require 'discount'
require 'items/lavender_heart'

class DummyTestClass
  include Discount
end

RSpec.describe Discount do
  let(:dummy_class) { DummyTestClass.new }

  describe '.discount_60_spend' do
    let(:value) { 100 }
    let(:items) { [] }

    subject { dummy_class.discount_60_spend(value, items) }

    it 'returns a discount of 10% of the value for values > 60' do
      expect(subject).to eq(10)
    end

    context 'when value is 60 or less' do
      let(:value) { 60 }
      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end
  end

  describe '.discount_2_hearts' do
    let(:value) { 100 }
    let(:heart_1) { LavenderHeart.new }
    let(:heart_2) { LavenderHeart.new }
    let(:items) { [heart_1, heart_2] }

    subject { dummy_class.discount_2_hearts(value, items) }

    it 'discounts each lavender heart to £8.50' do
      expect(subject).to eq(1.5)
    end

    context 'when there are less than 2 lavender hearts' do
      let(:items) { [heart_1] }
      it 'returns 0 discount' do
        expect(subject).to eq(0)
      end
    end
  end

  # context 'when the checkout has discounts applied' do
  #   let(:heart_1) { LavenderHeart.new }
  #   let(:heart_2) { LavenderHeart.new }
  #   let(:tshirt) { KidsTshirt.new }
  #   let(:cufflinks) { PersonalisedCufflinks.new }

  #   context 'when the total value is over £60' do
  #     before { scan_items([heart_1, tshirt, cufflinks]) }
  #     it 'discounts the final value by 10%' do
  #       expect(subject).to eq('£66.78')
  #     end
  #   end

  #   context 'when the basket contains 2+ lavender hearts' do
  #     before { scan_items([heart_1, heart_2, tshirt]) }
  #     it 'discounts each lavender heart to £8.50' do
  #       expect(subject).to eq('£36.95')
  #     end
  #   end

  #   context 'when the basket contains 2+ lavender hearts and is over £60' do
  #     before { scan_items([heart_1, heart_2, tshirt, cufflinks]) }
  #     it 'discounts each lavender heart to £8.50 and reduces the basket by 10%' do
  #       expect(subject).to eq('£73.76')
  #     end
  #   end
  # end

end