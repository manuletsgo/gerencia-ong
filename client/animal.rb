class Animal
  attr_accessor :name
  attr_accessor :type

  def initialize(name, type)
    @name = name
    @type = type
  end

  def to_s
    m = "Animal:"\
    + "\nName: #{@name}"\
    + "\nType: #{@type}"
    m
  end
end
