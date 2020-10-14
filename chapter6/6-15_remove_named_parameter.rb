class Books
  def self.find(selector, hash={})
    hash[:joins] ||= []
    hash[:conditions] ||= ""
    sql = ["SELECT FROM books"]
    hash[:joins].each do |join_table|
      sql << "LEFT OUTER JOIN #{join_table}"
      sql << "ON books.#{join_table.to_s.chomp}_id = #{join_table}.id"
    end
    sql << "WHERE #{hash[:conditions]}" unless hash[:conditions].empty?
    sql << "LIMIT 1" if selector == :first

    connection.find(sql.join(" "))
  end
end

# :all 全件、:first 1件 の結果が返ると予想がつくが引数なしの場合は、実装を見ないと、結果が何件返るかわからない
# selector という名前がわかりにくい問題もある
# selector 引数を必須にして、名前付きパラメータを取り除くことでわかりやすくした
Books.find(:all)
Books.find(:all,
           :conditions => "author.name = 'Jenny James'",
           :joins => [:authors])
Books.find(:first,
           :conditions => "author.name = 'JennyJames'",
           :joins => [:authors])
