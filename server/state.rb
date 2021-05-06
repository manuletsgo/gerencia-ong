require_relative 'adoption.rb'
require_relative 'message.rb'
require_relative 'state.rb'

class State
  attr_accessor :context

  # @abstract
  def login
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  # @abstract
  def logout
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  # @abstract
  def exit
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  # @abstract
  def cad
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  # @abstract
  def doa
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  # @abstract
  def conf
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  # @abstract
  def listani
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  # @abstract
  def adot
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  # @abstract
  def listado
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  # @abstract
  def cons
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  # @abstract
  def mant
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end


end

class Connected < State
  def login(message)
    response = Message.new('LOGINREPLY')
    begin
      username = message.params[:user]
      password = message.params[:pass]

      client = @context.server.clients[username.to_sym]

      if client and username == client.username and password == client.password
        response.set_status 200
        response.add_param :res, 'Login Successfully!'
        @context.client = client
        @context.transition_to Authenticated.new
      else
        response.set_status 400
        response.add_param :res, 'Invalid Username or Password!'
      end
    rescue => e
      raise e
      response.set_status 500
      response.add_param :res, 'Internal Server Error!'
    end
    @context.socket.write(Marshal.dump(response))
  end

  def logout(message)
    @context.default(message)
  end

  def exit(message)
    response = Message.new('EXITREPLY')
    response.set_status 200
    response.add_param :res, 'Connection is going to close!'
    @context.socket.write(Marshal.dump(response))
    @context.transition_to(Exiting.new)
  end

  def cad(message)
    @context.default(message)
  end

  def listani(message)
    @context.default(message)
  end

  def listado(message)
    @context.default(message)
  end

  def doa(message)
    @context.default(message)
  end

  def conf(message)
    @context.default(message)
  end

  def adot(message)
    @context.default(message)
  end

  def cons(message)
    @context.default(message)
  end

  def mant(message)
    @context.default(message)
  end
end

class Authenticated < State
  def login(message)
    @context.default(message)
  end

  def logout(message)
    response = Message.new('LOGOUTREPLY')
    begin
      response.set_status 200
      response.add_param :res, 'Logout Successfully!'
      @context.client = nil
      @context.transition_to Connected.new
    rescue => e
      raise e
      response.set_status 500
      response.add_param :res, 'Internal Server Error!'
    end
    @context.socket.write(Marshal.dump(response))
  end

  def exit(message)
    response = Message.new('EXITREPLY')
    response.set_status 200
    response.add_param :res, 'Connection is going to close!'
    @context.socket.write(Marshal.dump(response))
    @context.transition_to(Exiting.new)
  end

  def cad(message)
    response = Message.new('CADREPLY')
    begin
      if @context.client.type == 'admin'
        animal = message.params[:animal]
        if @context.server.ong.animals[animal.name] == nil
          @context.server.ong.animals[animal.name] = animal
          response.set_status 200
          response.add_param :res, 'Register Successfully!'
        else
          response.set_status 400
          response.add_param :res, 'Name is used!'
        end
      else
        response.set_status 401
        response.add_param :res, "Unauthorized method for #{@context.client.type}!"
      end
    rescue => e
      raise e
      response.set_status 500
      response.add_param :res, 'Internal Server Error!'
    end
    @context.socket.write(Marshal.dump(response))
  end

  def listani(message)
    response = Message.new('LISTANIREPLY')
    begin
      response.set_status 200
      response.add_param :res, @context.server.ong.show_animals
    rescue => e
      raise e
      response.set_status 500
      response.add_param :res, 'Internal Server Error!'
    end
    @context.socket.write(Marshal.dump(response))
  end

  def listado(message)
    response = Message.new('LISTADOREPLY')
    begin
      if @context.client.type == 'admin'
        response.set_status 200
        response.add_param :res, @context.server.ong.show_adoptions
      else
        response.set_status 401
        response.add_param :res, "Unauthorized method for #{@context.client.type}!"
      end
    rescue => e
      raise e
      response.set_status 500
      response.add_param :res, 'Internal Server Error!'
    end
    @context.socket.write(Marshal.dump(response))
  end

  def adot(message)
    response = Message.new('ADOTREPLY')
    begin
      if @context.client.type == 'protector'
        id = @context.server.ong.adoptions.length
        name = message.params[:name]
        phone = message.params[:phone]
        animal_name = message.params[:animal_name]
        animal = @context.server.ong.animals[animal_name]
        if animal
          adoption = Adoption.new id, name, phone, animal
          @context.server.ong.adoptions[id] = adoption
          response.set_status 200
          response.add_param :res, 'Adoption successfully!'
        else
          response.set_status 400
          response.add_param :res, 'Animal doesnt exists!'
        end
      else
        response.set_status 401
        response.add_param :res, "Unauthorized method for #{@context.client.type}!"
      end
    rescue => e
      raise e
      response.set_status 500
      response.add_param :res, 'Internal Server Error!'
    end
    @context.socket.write(Marshal.dump(response))
  end

  def doa(message)
    response = Message.new('DOAREPLY')
    begin
      if @context.client.type == 'protector'
        donation = message.params[:value].to_f
        if donation and donation > 0.0
          @context.server.ong.balance += donation
          response.set_status 200
          response.add_param :res, 'Donation successfully!'
        else
          response.set_status 400
          response.add_param :res, 'Parameters error!'
        end
      else
        response.set_status 401
        response.add_param :res, "Unauthorized method for #{@context.client.type}!"
      end
    rescue => e
      raise e
      response.set_status 500
      response.add_param :res, 'Internal Server Error!'
    end
    @context.socket.write(Marshal.dump(response))
  end

  def conf(message)
    response = Message.new('CONFREPLY')
    begin
      if @context.client.type == 'admin'
        id = message.params[:id].to_i
        status = message.params[:status]
        if @context.server.ong.adoptions[id]
          if @context.server.ong.adoptions[id].status == 'pending'
            if status == 'approved'
              @context.server.ong.adoptions[id].status = status
              @context.server.ong.animals.delete @context.server.ong.adoptions[id].animal.name
              response.set_status 200
              response.add_param :res, 'Adoption approved!'
            elsif status == 'reproved'
              @context.server.ong.adoptions[id].status = status
              response.set_status 200
              response.add_param :res, 'Adoption reproved!'
            else
              response.set_status 400
              response.add_param :res, 'Invalid status!'
            end
          else
            response.set_status 400
            response.add_param :res, 'Status from this adoption is not pending!'
          end
        else
          response.set_status 400
          response.add_param :res, 'Invalid adoption id!'
        end
      else
        response.set_status 401
        response.add_param :res, "Unauthorized method for #{@context.client.type}!"
      end
    rescue => e
      raise e
      response.set_status 500
      response.add_param :res, 'Internal Server Error!'
    end
    @context.socket.write(Marshal.dump(response))
  end

  def mant(message)
    response = Message.new('MANTREPLY')
    begin
      if @context.client.type == 'admin'
        value = message.params[:value].to_f
        if value and value > 0.0
          if @context.server.ong.balance >= value
            @context.server.ong.balance -= value
            response.set_status 200
            response.add_param :res, 'Order successfully!'
          else
            response.set_status 400
            response.add_param :res, 'Insuficient balance!'
          end
        else
          response.set_status 400
          response.add_param :res, 'Parameters error!'
        end
      else
        response.set_status 401
        response.add_param :res, "Unauthorized method for #{@context.client.type}!"
      end
    rescue => e
      raise e
      response.set_status 500
      response.add_param :res, 'Internal Server Error!'
    end
    @context.socket.write(Marshal.dump(response))
  end

  def cons(message)
    response = Message.new('CONSREPLY')
    begin
      if @context.client.type == 'admin'
        response.set_status 200
        response.add_param :res, @context.server.ong.balance
      else
        response.set_status 401
        response.add_param :res, "Unauthorized method for #{@context.client.type}!"
      end
    rescue => e
      raise e
      response.set_status 500
      response.add_param :res, 'Internal Server Error!'
    end
    @context.socket.write(Marshal.dump(response))
  end
end

class Exiting < State
  def login(message)
    true
  end

  def logout(message)
    true
  end

  def exit(message)
    true
  end

  def cad(message)
    true
  end

  def doa(message)
    true
  end

  def conf(message)
    true
  end

  def listani(message)
    true
  end

  def adot(message)
    true
  end

  def listado(message)
    true
  end

  def cons(message)
    true
  end

  def mant(message)
    true
  end

end
