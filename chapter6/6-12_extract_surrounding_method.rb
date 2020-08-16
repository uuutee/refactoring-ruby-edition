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
end
