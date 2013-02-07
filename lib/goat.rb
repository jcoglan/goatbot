require 'eventmachine'

class Goat
  root = File.expand_path('../goat', __FILE__)
  require root + '/net'
  require root + '/player'

  attr_accessor :username

  def initialize(host, port)
    @client = Net.new(self, host, port)
    @player = Player.new
  end

  def ask_for_name
    @client.send_name(@username)
  end

  def start_game

  end

  def update_letters(letters)
    @player.board = letters
  end

  def update_ownership(owners)
    @player.state = owners
  end

  def ask_for_move
    @player.pick
  end
end

