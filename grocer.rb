require 'pry'

def consolidate_cart(cart)
  new_hash = {}
  cart.each do |item|
    item_name = item.keys[0]
    if new_hash[item_name]
      new_hash[item_name][:count] += 1
    else
      new_hash[item_name] = {
        count: 1,
        price: item[item_name][:price],
        clearance: item[item_name][:clearance]
      }
    end
  end
  new_hash
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    coupon_item = coupon[:item]
    if cart.keys.include? coupon_item

        if cart[coupon_item][:count] >= coupon[:num]
          discounted_item = "#{coupon_item} W/COUPON"
          if cart[discounted_item]
            cart[discounted_item][:count] += coupon[:num]
          else
            cart[discounted_item] = {
              count: coupon[:num],
              price:  coupon[:cost]/coupon[:num],
              clearance: cart[coupon_item][:clearance]
            }
          end
          cart[coupon_item][:count] -= coupon[:num]
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.keys.each do |item|
    if cart[item][:clearance]
      cart[item][:price] = (cart[item][:price]*0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  total = 0

  consolidated_cart = consolidate_cart(cart)
  cart_after_coupons = apply_coupons(consolidated_cart, coupons)
  final = apply_clearance(cart_after_coupons)

  final.keys.each do |item|
    total += consolidated_cart[item][:price] * consolidated_cart[item][:count]
  end
  
  if total >= 100
    return (total * 0.9).round(2)
  else
    return total
  end
end
