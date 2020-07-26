require 'checkout'

RSpec.describe Checkout do
  
  subject { described_class.new }

  it 'initializes with default promotional_rules as an array' do
    expect(subject.promotional_rules).to be_a(Array)     
  end

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

    it 'updates the total of the checkout'
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
      let(:heart) { LavenderHeart.new }
      let(:tshirt) { KidsTshirt.new }
      let(:cufflinks) { PersonalisedCufflinks.new }

      context 'when the total value is over £60' do
        before do
          co.scan(heart)
          co.scan(tshirt)
          co.scan(cufflinks)
        end
        it 'discounts the final value by 10%' do
          expect(subject).to eq('£66.78')
        end
      end

      it 'discounts 2+ lavender hearts'
      it 'discounts 2+ lavender hearts and £60+ total'
    end
  end
end
