def consolidate_cart(cart_array)
  final_hash = {}

  cart_array.each do |hash|
    hash.each do |item, detail_hash|
      if final_hash[item]
        final_hash[item][:count] += 1
      else
        final_hash[item] = detail_hash
        final_hash[item][:count] = 1
      end
    end
  end
  final_hash
end

def apply_coupons(cart_hash, coupon_hash)
  final_hash = {}
  cart_hash.map do |food_item, food_item_attributes|
    final_hash[food_item] = food_item_attributes
    coupon_hash.each do |coupon|
      # if coupon item is in cart and the cart has equal or more items then the coupon requires
      if coupon[:item] == food_item && cart_hash[food_item][:count] >= coupon[:num]
        # then new food item with coupon is added to hash
        final_hash["#{food_item} W/COUPON"] = {:price => coupon[:cost], :clearance => cart_hash[food_item][:clearance], :count => cart_hash[food_item][:count]/coupon[:num]}
        final_hash[food_item][:count] = cart_hash[food_item][:count]%coupon[:num]
      end
    end
  end
  final_hash
end

def apply_clearance(cart)
  cart.map do |food_item, food_item_attributes|
    if cart[food_item][:clearance] == true
      cart[food_item][:price] = (cart[food_item][:price]*0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  # code here
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)

  cart_total = 0
  cart.each do |item, details_hash|
    cart_total += cart[item][:price] * cart[item][:count]
  end

  if cart_total >= 100
    cart_total = (cart_total * 0.9).round(2)
  end
  cart_total
end
