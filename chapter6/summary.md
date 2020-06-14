# メソッドの構成方法

## 6.1 メソッドの抽出 (Extract Method)

- コードの断片をメソッドにして、その目的を説明する名前をつける
- コメントは抽出できるメソッドを見分けることに使える

before

```ruby
def print_owring
  print_banner
  puts "name: #{@name}"
  puts "amount: #{@amount}"
end
```

after

```ruby
def print_owring
  print_banner
  print_details amount
end

def print_details(amount)
  puts "name: #{@name}"
  puts "amount: #{amount}"
end
```

### サンプル

https://github.com/uuutee/refactoring-ruby-edition/pull/1

## 6.2 メソッドのインライン化 (Inline Method)

- メソッドの本体を呼び出し元の本体に組み込み、メソッドを削除する

before

```ruby
def get_rating
  more_than_five_late_deliveries ? 2 : 1
end

def more_than_five_late_deliveries
  @number_of_late_deliveries > 5
end
```

after

```ruby
def get_rating
  @number_of_late_deliveries > 5 ? 2 : 1
end
```

### サンプル

https://github.com/uuutee/refactoring-ruby-edition/pull/2

## 6.3 一時変数のインライン化 (Inline Temp)

- 一時変数に対するすべての参照を取り除き、式にする
- 「一時変数から問い合わせメソッドへ」の一部として使うことが多い

before

```ruby
base_price = an_order.base_price
return (base_price > 1000)
```

after

```ruby
return (an_order.base_price > 1000)
```

### サンプル

https://github.com/uuutee/refactoring-ruby-edition/pull/3

## 6.4 一時変数から問い合わせメソッドへ (Replace Temp with Query)

- 式をメソッドにする。一時変数のすべての参照箇所を式に置き換える
  - 新しくメソッド化すれば他のメソッドからも利用可能になる
- 「メソッドの抽出」を行う前の重要なステップ
  - ローカル変数はメソッドの抽出の邪魔になるので

before

```ruby
base_price = @quantity * @item_price

if (base_price > 1000)
  base_price * 0.95
else
  base_price * 0.98
end
```

after

```ruby
if (base_price > 1000)
  base_price * 0.95
else
  base_price * 0.98
end

def base_price
  @quantity * @item_price
end
```

### サンプル

https://github.com/uuutee/refactoring-ruby-edition/pull/4

## 6.5 一時変数からチェインへ (Replace Temp with Chain)

- 一時変数を使って式の結果を保存している箇所
- チェイニングをサポートして、一時変数を不要にする
- 「委譲の隠蔽」とは異なる
  - 「委譲の隠蔽」 > カプセル化の問題
    - 呼び出し元のオブジェクトは、中間オブジェクトを経由せず、直接下位のオブジェクトを呼び出してはならず、必ず直近のオブジェクトに依頼しなければならない
  - 「一時変数からチェインへ」 > 1 つのオブジェクトの表現力を高めること

before

```ruby
mock = Mock.new
expectation = mock.expects(:a_method_name)
expectation.with("arguments")
expectation.returns([1, :array])
```

after

```ruby
mock = Mock.new
mock.expects(:a_method_name).with("arguments").returns([1, :array])
```

### サンプル

https://github.com/uuutee/refactoring-ruby-edition/pull/5

## 6.6 説明用変数の導入 (Introduce Explaning Variable)

- 複雑な条件分岐のコードの条件に適切に名前をつける
- 一時変数を使いすぎるとかえって見苦しくなる場合も多いため、「メソッドの抽出」をまず使えないかを考える

before

```ruby
if (platform.upcase.index("MAC")) &&
    browser.upcase.index("IE") &&
    initialized? &&
    resize > 0
    )
  # 何かをする
```

after

```ruby
is_mac_os = platform.upcase.index("MAC")
is_ie_browser = browser.upcase.index("IE")
was_resized = resize > 0

if (is_mac_os && is_ie_browser && initialized? && was_resized)
  # 何かをする
end
```

### サンプル

https://github.com/uuutee/refactoring-ruby-edition/pull/7

## 6.7 一時変数の分割 (Split Temporary Variable)

- ループ変数でも計算結果の蓄積用の変数でもないのに使いまわしされる変数には、代入ごとに適切に名前をつけた一時変数を用意する

before

```ruby
temp = 2 * (@height + @width)
puts temp
temp = @height * @width
puts temp
```

after

```ruby
perimeter = 2 * (@height + @width)
puts perimeter
area = @height * @width
puts area
```

### サンプル

https://github.com/uuutee/refactoring-ruby-edition/pull/8

## 6.8 引数への代入の除去 (Remove Assignments to Parameters)

- 引数で渡ってきた値をそのまま変更することをやめる
- 値渡しなのか、参照渡しなのかで混乱する
- コードの紛らわしさでいうと、引数は「渡されたものを表す」ということなので、それが計算結果としてそのまま用いられることはよくない

before

```ruby
def discount(input_val, quantity, year_to_date)
  if input_val > 50
    input_val -= 2
  end
end
```

after

```ruby
def discount(input_val, quantity, year_to_date)
  result = input_val
  if input_val > 50
    reuslt -= 2
  end
end
```

### 値渡しと参照渡し

Ruby は値渡しなので、関数内のスコープでのみ値が変更され、呼び出し元は影響を受けない

```ruby
x = 5
def triple(arg)
  arg = arg *3
  puts "arg in triple: #{arg}"
end
triple x
puts "x after triple #{x}"

# 関数内のみ値が変更されている
# => arg in triple: 15
# => x after triple 5
```

ただし、オブジェクトの状態を変更するメソッドを呼び出した場合は、呼び出し元の変数も影響を受ける

```ruby
# 台帳
class Ledger
  # 残高
  attr_reader :balance

  def initialize(balance)
    @balance = balance
  end

  def add(arg)
    @balance += arg
  end
end

class Product
  # 引数に渡された Ledger の値を Ledger 自身で更新して出力する
  def self.add_price_by_updating(ledger, price)
    ledger.add(price)
    puts "ledger in add_price_by_updating: #{ledger.balance}"
  end

  # 新しいオブジェクトを作り、その値を出力する
  def self.add_price_by_replacing(ledger, price)
    ledger = Ledger.new(ledger.balance + price)
    puts "ledger in add_price_by_replacing: #{ledger.balance}"
  end
end

l1 = Ledger.new(0)
Product.add_price_by_updating(l1, 5)
puts "l1 after add_price_by_updating: #{l1.balance}"

l2 = Ledger.new(0)
Product.add_price_by_replaceing(l2, 5)
puts "l2 after add_price_by_replaceing: #{l2.balance}"

# 自身のオブジェクトを更新した場合は、呼び出し元でも変更される
# => ledger in add_price_updating: 5
# => l1 after add_price_updating: 5

# 新しくオブジェクトを作った場合あh、呼び出し元で影響は受けない
# => ledger in add_price_updating: 5
# => l2 after add_price_updating: 0
```
