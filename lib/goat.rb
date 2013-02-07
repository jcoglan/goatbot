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
    @board = letters
  end

  def update_ownership(owners)
    @state_of_board = owners
  end

  def ask_for_move
    player = Player.new(@board, nil)
    player.pick(@state_of_board)
  end
end

