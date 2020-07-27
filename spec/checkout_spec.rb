require 'require_all'
require 'checkout'
require_all 'lib/items'

RSpec.describe Checkout do
  let(:item) { double('PersonalisedCufflinks') }

  subject { described_class.new }

  it 'initializes with default promotional_rules as an array' do
    expect(subject.promotional_rules).to be_a(Array)
  end

  it 'can have promotional_rules passed in'

  it 'initializes with an empty set of items' do
    expect(subject.items).to eq([])
  end

  describe '.scan' do
    let(:co) { described_class.new }
    subject { co.scan(item) }

    it 'adds items to the set of items' do
      expect { subject }.to change { co.items }.from([]).to([item])
    end
  end

  describe '.total' do
    let(:co) { described_class.new }
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

    # TODO: - move these, test discounts elsewhere!
    context 'when the checkout has discounts applied' do
      let(:heart_1) { LavenderHeart.new }
      let(:heart_2) { LavenderHeart.new }
      let(:tshirt) { KidsTshirt.new }
      let(:cufflinks) { PersonalisedCufflinks.new }

      context 'when the total value is over £60' do
        before { scan_items([heart_1, tshirt, cufflinks]) }
        it 'discounts the final value by 10%' do
          expect(subject).to eq('£66.78')
        end
      end

      context 'when the basket contains 2+ lavender hearts' do
        before { scan_items([heart_1, heart_2, tshirt]) }
        it 'discounts each lavender heart to £8.50' do
          expect(subject).to eq('£36.95')
        end
      end

      context 'when the basket contains 2+ lavender hearts and is over £60' do
        before { scan_items([heart_1, heart_2, tshirt, cufflinks]) }
        it 'discounts each lavender heart to £8.50 and reduces the basket by 10%' do
          expect(subject).to eq('£73.76')
        end
      end
    end
  end
end
