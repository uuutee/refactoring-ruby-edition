def print_owring
  print_banner
  outstanding = calculate_outstanding
  print_details outstanding
end

def calculate_outstanding
  outstanding = 0.0

  # 勘定を計算
  @orders.each do |order|
    outstanding += order.amount
  end
  outstanding
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
