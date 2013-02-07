require 'eventmachine'

class Goat
  root = File.expand_path('../goat', __FILE__)
  require root + '/net'

  attr_accessor :username

  def initialize(host, port)
    @client = Net.new(self, host, port)
  end

  def ask_for_name
    @client.send_name(@username)
  end

  def update_letters(letters)
    # TODO
  end

  def update_ownership(owners)
    # TODO
  end

  def ask_for_move
    [[1,2],[3,4]]
  end
end

