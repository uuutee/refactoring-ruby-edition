# 家系図をモデリングする例
# 母親(Person)は何人もの子(Person)を持つことができる
# 同じクラスへの自己参照的な has_many の関係

class Person
  attr_reader :mother, :children, :name

  def initialize(name, date_of_birth, date_of_death=nil, mother=nil)
    @name, @mother = name, mother
    @date_of_birth, @date_of_death = date_of_birth, date_of_death
    @children = []
    @mother.add_child(self) if @mother
  end

  def add_child(child)
    @children << child
  end

  # 生きている子孫の数を数えるメソッド
  # 再帰的に、自身の子が生きていれば +1 する
  def number_of_living_descendants
    children.inject(0) do |count, child|
      count += 1 if child.alive?
      count + child.number_of_living_descendants
    end
  end

  # 特定の名前を持つ子孫の数を数えるメソッド
  # 再帰的に、自身の子が指定した名前と同じ名前であれば +1 する
  def number_of_descendants_named(name)
    count_descendants_matching { |descendant| descendant.name == name }
  end

  def alive?
    @date_of_death.nil?
  end

  protected

  def count_descendants_matching(&block)
    children.inject(0) do |count, child|
      count += 1 if yield child
      count + child.count_descendants_matching(&block)
    end
  end
end
