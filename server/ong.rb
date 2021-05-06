require_relative 'adoption.rb'
require_relative 'animal.rb'

class Ong
  attr_accessor :animals
  attr_accessor :adoptions
  attr_accessor :balance

  def initialize
    @animals = {}
    @adoptions = {}
    @balance = 0.0
  end

  def show_animals
    m = "\n--------------"
    @animals.each do |key, animal|
      m += "\n"+@animals[key].to_s
    end
    m
  end

  def show_adoptions
    m = "\n--------------"
    @adoptions.each do |key, adoption|
      m += "\n"+@adoptions[key].to_s
    end
    m
  end
end
