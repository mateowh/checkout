# Checkout kata

Solving a checkout kata. Given an online marketplace, create a checkout to calculate the value of a set of items, given a set of promotional rules.

## Summary

Price list:
```
Item | Name | Price
001 | Lavender heart | £9.25
002 | Personalised cufflinks | £45.00
003 | Kids T-shirt | £19.95
```

Promotional rules:
```
Our check-out can scan items in any order, and because *our promotions will change*, it needs to be flexible regarding our promotional rules.

- If you spend over £60, then you get 10% of your purchase
- If you buy 2 or more lavender hearts then the price drops to £8.50.
```

## Notes on design

In how discounts work, I have had to make some trade offs. Whilst the system is simple and the scope is very narrow, I have optimised for things to be easily changed and keeping interfaces as basic as possible.

The consequence of this is having traded off some performance. For example keeping discounts generic and assuming each one has access to both the items being purchased and the running cost of the items.

This means the set of information is quite broad, and efficiency calculating discounts is less than optimal - however - I am prioritising flexibility here, until such a time as things can be refined.

## Assumptions

These are assumptions made for now, in order to keep the implementation as simple as possible (but which could be changed later on):
- Users cannot remove items from their basket once in there (this means directly updating the price of an item is okay for now)