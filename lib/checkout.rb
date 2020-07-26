class Checkout
  def initialize
    @items = []
  end

  def scan(item)
    @items << item
  end

  attr_reader :items
end