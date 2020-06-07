def print_owring
  outstanding = 0.0

  print_banner

  # 勘定を計算
  @orders.each do |order|
    outstanding += order.amount
  end

  print_details outstanding
end

def print_banner
  # バナーを出力
  puts "*************************"
  puts "***** Customer Owes *****"
  puts "*************************"
end

def print_details(outstanding)
  # 詳細を表示
  puts "name: #{@name}"
  puts "amount: #{outstanding}"
end
