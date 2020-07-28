require_relative 'promotion'

class Checkout
  include Promotion

  def initialize(promotional_rules)
    @items = []
    @promotional_rules = promotional_rules
  end

  def scan(item)
    @items << item
  end

  def total
    present(price_after_promotions)
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

  def price_after_promotions
    basket_total = raw_basket_cost
    promotional_rules.each { |promotion| basket_total -= public_send(promotion, basket_total, items) }
    basket_total
  end
end
