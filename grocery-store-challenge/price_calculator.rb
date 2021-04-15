class PriceCalculator
  PRICING_TABLE = { milk: 3.97, bread: 2.17, banana: 0.99, apple: 0.89 }.freeze
  SALE_PRICING = { milk: { volume: 2, price: 5 }, bread: { volume: 3, price: 6 } }.freeze

  attr_accessor :items, :total_price, :total_discount_price

  def initialize(items)
    @total_price = 0
    @total_discount_price = 0
    @items = items
  end

  def items_count_map
    items.each_with_object(Hash.new(0)) do |item, result|
      result[item] += 1
    end
  end

  def execute
    items_count_map.map do |item, volume|
      sale_price, discount_price = price(item, volume)
      self.total_price += sale_price
      self.total_discount_price += discount_price
      [item.to_s.capitalize.ljust(8, ' '), volume.to_s.ljust(13, ' '), sale_price].join(' ')
    end
  end

  def price(item, volume)
    return [0, 0] unless PRICING_TABLE.key? item

    item_actual_price = PRICING_TABLE[item]
    price = item_actual_price * volume
    return [price, 0] unless item_on_sale?(item)

    sale_volume = SALE_PRICING.dig(item, :volume)
    item_sale_price = SALE_PRICING.dig(item, :price)
    discount_items = volume / sale_volume
    non_discount_items = volume % sale_volume

    discounted_price = (discount_items * item_sale_price) + (non_discount_items * item_actual_price)

    [discounted_price, price - discounted_price]
  end

  def item_on_sale?(item)
    SALE_PRICING.key?(item)
  end
end

puts 'Please enter all the items purchased separated by a comma'
items = gets.strip.delete(' ').split(',').map(&:to_sym)
puts "\n"
puts 'Item     Quantity      Price'
puts '--------------------------------------'
calculator = PriceCalculator.new(items)
puts calculator.execute
puts "\n"
puts "Total price : $#{calculator.total_price}"
puts "You saved $#{calculator.total_discount_price.round(2)} today."
