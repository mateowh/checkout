require 'checkout'
require 'discount'

RSpec.describe Checkout do
  let(:item) { double('PersonalisedCufflinks') }
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

    def scan_items(items)
      items.each { |item| co.scan(item) }
    end

    let(:item) { double('PersonalisedCufflinks') }

    it { is_expected.to eq('£0.00') }

    context 'when checkout has items' do
      before do
        allow(item).to receive(:price).and_return(10)
        scan_items([item])
      end

      it { is_expected.to eq('£10.00') }

      context 'when there are multiple items' do
        let(:another_item) { double('KidsTshirt') }
        before do
          allow(another_item).to receive(:price).and_return(15)
          scan_items([another_item])
        end
        it { is_expected.to eq('£25.00') }
      end

      context 'and an item value needs to be rounded' do
        before do
          allow(item).to receive(:price).and_return(9.9999999)
          scan_items([item])
        end
        it 'rounds correctly to pounds and pence' do
          expect(subject).to eq('£20.00')
        end
      end
    end

    context 'when the checkout has discounts applied' do
      before { allow_any_instance_of(Discount).to receive(:discount_60_spend).and_return(60) }
      let(:promotional_rules) { [:discount_60_spend] }
      let(:co) { described_class.new(promotional_rules) }

      before do
        allow(item).to receive(:price).and_return(100)
        scan_items([item])
      end

      it 'applies these discounts to the total' do
        expect(subject).to eq('£40.00')
      end
    end
  end
end
