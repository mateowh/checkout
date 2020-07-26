DISCOUNTS = [
  ->(price) { price > 60 ? price * 0.1 : 0 }
]

class Checkout
  def initialize(promotional_rules = DISCOUNTS)
    @items = []
    @promotional_rules = promotional_rules
  end

  def scan(item)
    @items << item
  end

  def total
    present(price_after_discounts)
  end

  attr_reader :items, :promotional_rules

  private

  def present(cost)
    final_bill = format('%.2f', cost)
    "£#{final_bill}"
  end

  def raw_basket_cost
    items.sum(&:price)
  end

  def price_after_discounts
    value = raw_basket_cost
    promotional_rules.each { |discount| value -= discount.call(value) }
    value
  end
end
