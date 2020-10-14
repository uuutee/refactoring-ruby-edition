class Hash
  def to_module
    hash = self
    Module.new do
      hash.each_pair do |key, value|
        define_method key do
          value
        end
      end
    end
  end
end

class PostData
  def initialize(post_data)
    # 1. 受け取ったHashの #to_module を呼び出す
    # 2. #to_module は Hash のキー名を動的にメソッド化した Module を返す
    # 3. 動的に定義されたメソッドの Module を extend (継承) する
    # 4. インスタンス内で動的なメソッドが利用できるようになる
    self.extend post_data.to_module
  end
end
