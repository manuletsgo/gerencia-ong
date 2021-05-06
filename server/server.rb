require 'socket'
require_relative 'adoption.rb'
require_relative 'animal.rb'
require_relative 'client.rb'
require_relative 'context.rb'
require_relative 'message.rb'
require_relative 'ong.rb'
require_relative 'state.rb'

class Server
  attr_accessor :clients
  attr_accessor :socket
  attr_accessor :ong

  def initialize(port)
    admin = Client.new 'admin', '123', 'admin'
    protector = Client.new 'prot', '1234', 'protector'
    @clients = {admin.username.to_sym => admin}
    @clients[protector.username.to_sym] = protector
    @ong = Ong.new
    @socket = TCPServer.open(port)
  end

  def handle_connection(client)
    begin
      @context = Context.new(Connected.new, client, self)

      while !@context.state.is_a? Exiting do
        message = Marshal.load(client.recv(1024))
        puts("\n-> Message received: \n#{message}\n")
        operation = message.operation

        if @context.respond_to? operation.downcase
          @context.send(operation.downcase, message)
        else
          @context.default(message)
        end
      end
    rescue => e
      raise e
    ensure
      client.close
      puts('Connection closed!')
    end
  end
end

begin
  @server = Server.new(33333)
  puts('Server started!')
  loop {
    puts('Waiting connections!')
    Thread.start(@server.socket.accept) do |client|
      @server.handle_connection(client)
    end
  }
rescue => e
  raise e
end
