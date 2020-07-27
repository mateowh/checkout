require 'require_all'
require 'checkout'
require_all 'lib/items'

RSpec.describe Checkout do
  subject { described_class.new }

  it 'initializes with default promotional_rules as an array' do
    expect(subject.promotional_rules).to be_a(Array)
  end

  it 'can have promotional_rules passed in'

  it 'initializes with an empty set of items' do
    expect(subject.items).to eq([])
  end

  describe '.scan' do
    # TODO: DRY this
    let(:item) { double('Item') }
    let(:co) { Checkout.new }
    subject { co.scan(item) }

    it 'adds items to the set of items' do
      expect { subject }.to change { co.items }.from([]).to([item])
    end
  end

  describe '.total' do
    let(:co) { Checkout.new }
    subject { co.total }

    it { is_expected.to eq('£0.00') }

    context 'when checkout has an item' do
      # TODO: DRY this
      before do
        item = double('Item')
        allow(item).to receive(:price).and_return(10)
        co.scan(item)
      end

      it { is_expected.to eq('£10.00') }

      context 'and that items value needs to be rounded' do
        # TODO: DRY this
        before do
          item = double('Item')
          allow(item).to receive(:price).and_return(9.999)
          co.scan(item)
        end
        it 'rounds correctly' do
          expect(subject).to eq('£20.00')
        end
      end

      context 'when there are multiple items' do
        # TODO: DRY this
        before do
          another_item = double('Item')
          allow(another_item).to receive(:price).and_return(15)
          co.scan(another_item)
        end

        it { is_expected.to eq('£25.00') }
      end
    end

    context 'when the checkout has discounts applied' do
      let(:heart_1) { LavenderHeart.new }
      let(:heart_2) { LavenderHeart.new }
      let(:tshirt) { KidsTshirt.new }
      let(:cufflinks) { PersonalisedCufflinks.new }

      context 'when the total value is over £60' do
        before do
          co.scan(heart_1)
          co.scan(tshirt)
          co.scan(cufflinks)
        end
        it 'discounts the final value by 10%' do
          expect(subject).to eq('£66.78')
        end
      end

      context 'when the basket contains 2+ lavender hearts' do
        before do
          co.scan(heart_1)
          co.scan(heart_2)
          co.scan(tshirt)
        end
        it 'discounts each lavender heart to £8.50' do
          expect(subject).to eq('£36.95')
        end
      end

      context 'when the basket contains 2+ lavender hearts and is over £60' do
        before do
          co.scan(heart_1)
          co.scan(heart_2)
          co.scan(tshirt)
          co.scan(cufflinks)
        end
        it 'discounts each lavender heart to £8.50 and reduces the basket by 10%' do
          expect(subject).to eq('£73.76')
        end
      end
    end
  end
end
