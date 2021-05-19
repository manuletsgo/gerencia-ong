require 'securerandom'

class Adoption
  attr_accessor :id
  attr_accessor :name
  attr_accessor :phone
  attr_accessor :animal
  attr_accessor :status
  attr_accessor :client

  def initialize(id, name, phone, animal, client)
    @id = id
    @name = name
    @phone = phone
    @animal = animal
    @status = 'pending'
    @client = client
  end

  def to_s
    m = "\n- Adoption: #{@id}"\
    + "\n- - Name: #{@name}"\
    + "\n- - Phone: #{@phone}"\
    + "\n- #{@animal}"\
    + "\n- - Status: #{@status}"
    m
  end
end
