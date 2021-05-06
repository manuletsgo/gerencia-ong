class Message
  attr_accessor :operation
  attr_accessor :params
  attr_accessor :status

  def initialize(operation)
    @operation = operation
    @params = {}
    @status = nil
  end

  def set_operation(operation)
    @operation = operation
  end

  def add_param(key, value)
    @params[key] = value
  end

  def set_status(status)
    @status = status
  end

  def to_str
    to_s
  end

  def to_s
    m = "Operation: #{@operation}"\
    + "\nStatus: #{@status}"\
    + "\nParams:"
    @params.each do |key, value|
      m += "\n- #{key}: #{value}"
    end
    m
  end
end
