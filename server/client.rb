class Client
  attr_accessor :username
  attr_accessor :password
  attr_accessor :type

  def initialize(username, password, type)
    @username = username
    @password = password
    @type = type
  end
end
