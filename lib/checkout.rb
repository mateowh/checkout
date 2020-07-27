# TODO: move this - item specific logic should not live in checkout
require 'items/lavender_heart'

DISCOUNTS = [
  # TODO: move to module namespace to allow for tests & import here
  # TODO: refactor these methods
  # TODO: interpolate class name - no magic string
  lambda do |_value, items|
    # heart_count = items.count { |x| x.class.name == 'LavenderHeart' }
    heart_count = items.count { |x| x.is_a? LavenderHeart }
    heart_count >= 2 ? heart_count * 0.75 : 0
  end,
  ->(value, _items) { value > 60 ? value * 0.1 : 0 }
].freeze

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
    # TODO: delegate this to a caluclator class?
    value = raw_basket_cost
    DISCOUNTS.each { |discount| value -= discount.call(value, items) }
    value
  end
end
