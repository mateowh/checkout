require 'promotion'
require 'items/lavender_heart'

class DummyTestClass
  include Promotion
end

RSpec.describe Promotion do
  let(:dummy_class) { DummyTestClass.new }

  describe '.discount_60_spend' do
    let(:basket_total) { 100 }
    let(:items) { [] }

    subject { dummy_class.discount_60_spend(basket_total, items) }

    it 'returns a discount of 10% of the basket total for values > 60' do
      expect(subject).to eq(10)
    end

    context 'when basket total is 60 or less' do
      let(:basket_total) { 60 }
      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end
  end

  describe '.discount_2_hearts' do
    let(:basket_total) { 100 }
    let(:heart_1) { LavenderHeart.new }
    let(:heart_2) { LavenderHeart.new }
    let(:items) { [heart_1, heart_2] }

    subject { dummy_class.discount_2_hearts(basket_total, items) }

    it 'discounts each lavender heart to £8.50' do
      expect(subject).to eq(1.5)
    end

    context 'when there are less than 2 lavender hearts' do
      let(:items) { [heart_1] }
      it 'returns 0 discount' do
        expect(subject).to eq(0)
      end
    end

    context 'when there are 2 other items (not lavender hearts)' do
      let(:other_item_1) { instance_double('PersonalisedCufflinks') }
      let(:other_item_2) { instance_double('PersonalisedCufflinks') }
      let(:items) { [other_item_1, other_item_2] }
      it 'does not discount anything' do
        expect(subject).to eq(0)
      end
    end
  end
end
