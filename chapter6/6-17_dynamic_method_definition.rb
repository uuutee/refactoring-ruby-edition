class Class
  def def_each(*method_names, &block)
    method_names.each do |method_name|
      define_method method_name do
        instance_exec method_name, &block
      end
    end
  end
end

def_each :failure, :error, :success do |method_name|
  self.state = method_name
end
