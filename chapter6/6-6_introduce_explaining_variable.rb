def price
  # 価格は、基本価格 - 数量割引 + 配送料
  base_price = @quantity * @item_price
  return base_price - 
    [0, @quantity - 500].max * @item_price * 0.05 + 
    [@quantity * @item_price * 0.1, 100.0].min
end
