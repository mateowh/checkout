module Discount
  LIVE_DISCOUNTS = [
    # item discounts
    :discount_2_hearts,

    # basket total discounts
    :discount_60_spend
  ].freeze

  def discount_60_spend(basket_total, _items)
    return basket_total * 0.1 if basket_total > 60

    0
  end

  def discount_2_hearts(_basket_total, items)
    heart_count = items.count { |x| x.is_a? LavenderHeart }
    return 0 unless heart_count >= 2

    per_unit_discount = 0.75
    heart_count * per_unit_discount
  end
end
