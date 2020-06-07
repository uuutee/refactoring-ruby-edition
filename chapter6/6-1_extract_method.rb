def print_owring
  print_banner
  outstanding = calculate_outstanding
  print_details outstanding
end

def calculate_outstanding
  @orders.inject(0.0) { |result, order| result + order.amount }
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
