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

## 6.４ 一時変数から問い合わせメソッドへ (Replace Temp with Query)

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
https://github.com/uuutee/refactoring-ruby-edition/pull/2

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
