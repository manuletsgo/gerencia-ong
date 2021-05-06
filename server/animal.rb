class Animal
  attr_accessor :name
  attr_accessor :type

  def initialize(name, type)
    @name = name
    @type = type
  end

  def to_s
    m = "- Animal:"\
    + "\n- - Name: #{@name}"\
    + "\n- - Type: #{@type}\n"
    m
  end
end
