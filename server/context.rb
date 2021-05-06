require 'securerandom'
require_relative 'adoption.rb'
require_relative 'animal.rb'
require_relative 'message.rb'

class Context
  attr_accessor :state
  attr_accessor :client
  attr_accessor :socket
  attr_accessor :server

  def initialize(state, socket, server)
    transition_to(state)
    @socket = socket
    @id = SecureRandom.uuid
    @server = server
  end

  def transition_to(state)
    puts("\nContext transition to state: #{state.class}\n")
    @state = state
    @state.context = self
  end

  def login(message)
    @state.login(message)
  end

  def logout(message)
    @state.logout(message)
  end

  def exit(message)
    @state.exit(message)
  end

  def cad(message)
    @state.cad(message)
  end

  def doa(message)
    @state.doa(message)
  end

  def conf(message)
    @state.conf(message)
  end

  def listani(message)
    @state.listani(message)
  end

  def adot(message)
    @state.adot(message)
  end

  def listado(message)
    @state.listado(message)
  end

  def cons(message)
    @state.cons(message)
  end

  def mant(message)
    @state.mant(message)
  end

  def default(message)
    response = Message.new("#{message.operation}REPLY")
    response.set_status 401
    response.add_param :res, 'Invalid operation for state!'
    @socket.write(Marshal.dump(response))
  end
end
