module Discount
  LIVE_DISCOUNTS = [
    # item discounts
    :discount_2_hearts,

    # basket value discounts
    :discount_60_spend
  ].freeze

  def discount_60_spend(value, _items)
    return value * 0.1 if value > 60

    0
  end

  def discount_2_hearts(_value, items)
    heart_count = items.count { |x| x.is_a? LavenderHeart }
    return heart_count * 0.75 if heart_count >= 2

    0
  end
end
