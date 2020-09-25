module CustomInitializers
  def hash_initializer(*attribute_names)
    define_method(:initialize) do |*args|
      data = args.first || {}
      attribute_names.each do |attribute_name|
        instance_variable_set "@#{attribute_name}", data[attribute_name]
      end
    end
  end
end

Class.send :include, CustomInitializers

class SearchCriteria
  hash_initializer :author_id, :publisher_id, :isbn
end
criteria = SearchCriteria.new(:author_id => 5, :publisher_id => 8, :isbn => "0201485672")
