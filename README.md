# Checkout kata

This project implements a solution to a checkout kata.

## Summary

Given an online marketplace, implement a checkout system which allows customers to scan items, applies any promotional offers, and calculates the total cost of the order.

There are 3 items available:
```
Item | Name | Price
001 | Lavender heart | £9.25
002 | Personalised cufflinks | £45.00
003 | Kids T-shirt | £19.95
```

There are two promotions on offer at the moment:
```
- If you spend over £60, then you get 10% off your total purchase
- If you buy 2 or more lavender hearts then the price per unit drops to £8.50
```

Promotions are applied the same irrespective of the order in which items are scanned. Promotions may change in the future, so they need to be flexible in this regard.

Example basket values:
- `[001,002,003] => £66.78`
- `[001,003,001] => £36.95`
- `[001,002,001,003] => £73.76`

## How to run it

Run `bundle install` from the terminal to install the gems.

The program can be run using irb in these steps:
- Start `irb` from the terminal
- To require the right files run `load './require_files.rb'` - this loads everything from lib. (Alternatively you can load individual files using `require ./some_file.rb`)

You can now run an example, like this:
```ruby
promotions = Promotion::LIVE_PROMOTIONS # get the live promotions
co = Checkout.new(promotions)

lh = LavenderHeart.new
pc = PersonalisedCufflinks.new
kt = KidsTshirt.new

co.scan(lh) # scans the lavender heart and adds it to the checkout items
co.scan(pc) # scans the cufflinks and adds it to the checkout items
co.scan(kt) # scans the t-shirt and adds it to the checkout items

co.total # => "£66.78" returns the total basket value after promotions
```

The project has specs in rspec with test coverage metrics, run them from the terminal using:
- `bundle exec rspec`

The project has rubocop as a linter, run it from the terminal using:
- `bundle exec rubocop`

## Promotions

Promotions in the system take the form of methods, which live in the `Promotion` module, with each promotion represented by an individual method. Any live promotions to be applied are stored in `Promotion::LIVE_PROMOTIONS` array, and passed into the `Checkout`.

This makes adding/removing promotions relatively simple to do - if the method is in `Promotion::LIVE_PROMOTIONS` array when passed to the `Checkout`, it will be applied.

Each method is called and passed `items` & `basket_total` (running total cost of the items) as arguments - and returns an amount to be subtracted from the basket total.

A note on tradeoffs... promotions have been implemented this way to prioritise flexibility and ease to change them. This comes at a small cost of efficiency - e.g. not all methods use both `items` and `basket_total` in their calculations. Right now, the scope is narrow, and this could be refined in a later iteration, as more promotions are added and common patterns emerge to refactor.

Each promotion is individually tested in the `promotion_spec.rb`.

## Assumptions

These are assumptions made to keep implementation simple:
- Users cannot remove items once scanned
- The checkout only supports one currency (£)