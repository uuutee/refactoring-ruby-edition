class Select
  def self.with_option(option)
    select = self.new
    select.options << option
    select
  end

  def options
    @options ||= []
  end

  def add_option(arg)
    options << arg
    self
  end
end

select = Select.with_option(1999).add_option(2000).add_option(2001).add_option(2002)
