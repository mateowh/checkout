require 'checkout'
require 'discount'

RSpec.describe Checkout do
  let(:item) { instance_double('PersonalisedCufflinks') }
  let(:promotional_rules) { [] }

  subject { described_class.new(promotional_rules) }

  it 'initializes with default promotional_rules as an array' do
    expect(subject.promotional_rules).to be_a(Array)
  end

  it 'initializes with an empty set of items' do
    expect(subject.items).to eq([])
  end

  context 'when passing in promotional rules' do
    let(:promotion) { def promo_discount; end }
    let(:promotional_rules) { [:promotion] }
    it 'initializes with these' do
      expect(subject.promotional_rules).to eq(promotional_rules)
    end
  end

  describe '.scan' do
    let(:co) { described_class.new([]) }
    subject { co.scan(item) }

    it 'adds items to the set of items' do
      expect { subject }.to change { co.items }.from([]).to([item])
    end
  end

  describe '.total' do
    let(:promotional_rules) { [] }
    let(:co) { described_class.new(promotional_rules) }
    subject { co.total }

    let(:item) { instance_double('PersonalisedCufflinks') }

    it { is_expected.to eq('£0.00') }

    context 'when checkout has items' do
      before do
        allow(item).to receive(:price).and_return(10)
        co.scan(item)
      end

      it { is_expected.to eq('£10.00') }

      context 'when there are multiple items' do
        let(:another_item) { instance_double('KidsTshirt') }
        before do
          allow(another_item).to receive(:price).and_return(15)
          co.scan(another_item)
        end
        it { is_expected.to eq('£25.00') }
      end

      context 'and the basket value needs to be rounded' do
        let(:item_to_round) { instance_double('KidsTshirt') }
        before do
          allow(item_to_round).to receive(:price).and_return(29.9999999)
          co.scan(item_to_round)
        end
        it 'rounds correctly to pounds and pence' do
          expect(subject).to eq('£40.00')
        end
      end
    end

    context 'when the checkout has discounts applied' do
      before { allow_any_instance_of(Discount).to receive(:discount_60_spend).and_return(60) }
      let(:promotional_rules) { [:discount_60_spend] }
      let(:co) { described_class.new(promotional_rules) }

      before do
        allow(item).to receive(:price).and_return(100)
        co.scan(item)
      end

      it 'applies these discounts to the total' do
        expect(subject).to eq('£40.00')
      end
    end
  end

  context 'when integrating with existing items & discounts' do
    let(:promotional_rules) { Discount::LIVE_DISCOUNTS }
    let(:heart_1) { LavenderHeart.new }
    let(:heart_2) { LavenderHeart.new }
    let(:tshirt) { KidsTshirt.new }
    let(:cufflinks) { PersonalisedCufflinks.new }

    subject { described_class.new(promotional_rules) }

    def scan_multiple_items(items)
      items.each { |item| subject.scan(item) }
    end

    context 'when the basket total is over £60' do
      before { scan_multiple_items([heart_1, tshirt, cufflinks]) }
      it 'discounts the basket total by 10%' do
        expect(subject.total).to eq('£66.78')
      end
    end

    context 'when the basket contains 2+ lavender hearts' do
      before { scan_multiple_items([heart_1, heart_2, tshirt]) }
      it 'discounts each lavender heart to £8.50' do
        expect(subject.total).to eq('£36.95')
      end
    end

    context 'when the basket contains 2+ lavender hearts and is over £60' do
      before { scan_multiple_items([heart_1, heart_2, tshirt, cufflinks]) }
      it 'discounts each lavender heart to £8.50 and reduces the basket by 10%' do
        expect(subject.total).to eq('£73.76')
      end
    end
  end
end
