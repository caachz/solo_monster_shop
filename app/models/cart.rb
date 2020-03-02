class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents
  end

  def add_item(item)
    @contents[item] = 0 if !@contents[item]
    @contents[item] += 1
  end

  def total_items
    @contents.values.sum
  end

  def items
    item_quantity = {}
    @contents.each do |item_id,quantity|
      item_quantity[Item.find(item_id)] = quantity
    end
    item_quantity
  end

  def subtotal(item)
    discount = item.discount(@contents[item.id.to_s])
    if !discount
      item.price * @contents[item.id.to_s]
    else
      percent = 1 - discount.discount * 0.01
      ((item.price * percent) * @contents[item.id.to_s])
    end
  end

  def total
    @contents.sum do |item_id,quantity|
      Item.find(item_id).price * quantity
    end
  end

  def limit_reached?(item_id)
    Item.find(item_id).inventory <= contents[item_id]
  end

  def add_quantity(item_id)
    contents[item_id] += 1
  end

  def subtract_quantity(item_id)
    contents[item_id] -= 1
  end

  def quantity_zero?(item_id)
    contents[item_id] == 0
  end
end
