def print_owring
  outstanding = 0.0

  # バナーを出力
  puts "*************************"
  puts "***** Customer Owes *****"
  puts "*************************"

  # 勘定を計算
  @orders.each do |order|
    outstanding += order.amount
  end

  # 詳細を表示
  puts "name: #{@name}"
  puts "amount: #{@amount}"
end
