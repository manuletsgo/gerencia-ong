require_relative 'message.rb'
require_relative 'animal.rb'
require 'socket'

class Client
  def connect(host, port)
    @socket = TCPSocket.open(host, port)
  end

  def handle_connection
    begin
      @exit = false

      while !@exit
        puts("\nType the operation:")
        operation = gets.chomp.upcase

        if operation != nil
          message = Message.new(operation)

          if operation == 'LOGIN'
            puts('Type the username:')
            message.add_param :user, gets.chomp
            puts('Type the password:')
            message.add_param :pass, gets.chomp

          elsif operation == 'CAD'
            puts('Type the name:')
            name = gets.chomp
            puts('Type the type:')
            type = gets.chomp
            if name and type
              animal = Animal.new name, type
              message.add_param :animal, animal
            else
              puts 'Name and Type required!'
              next
            end

          elsif operation == 'ADOT'
            puts('Type your name:')
            message.add_param :name, gets.chomp
            puts('Type your phone:')
            message.add_param :phone, gets.chomp
            puts('Type the name of the animal to adopt:')
            message.add_param :animal_name, gets.chomp

          elsif operation == 'DOA' or operation == 'MANT'
            puts('Type the value:')
            message.add_param :value, gets.chomp

          elsif operation == 'CONF'
            puts('Type the id of the adoption:')
            message.add_param :id, gets.chomp
            puts('Type the status to confirm:')
            message.add_param :status, gets.chomp

          elsif operation == 'EXIT'
            @exit = true

          end

          @socket.write(Marshal.dump(message))
          @response = Marshal.load(@socket.recv(1024))
          puts("\n-> Message received: \n#{@response}\n")

        else
          puts 'Invalid Operation! x.x'
        end
      end
    rescue => e
      raise e
    ensure
      @socket.close
    end
  end
end

@client = Client.new
puts('Client initialized!')
@client.connect('localhost', 33333)
puts('Connection established!')
@client.handle_connection
