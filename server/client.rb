class Client
  attr_accessor :username
  attr_accessor :password
  attr_accessor :type
  attr_accessor :semaphore

  def initialize(username, password, type)
    @username = username
    @password = password
    @type = type
    @semaphore = ConditionVariable.new
  end
end
