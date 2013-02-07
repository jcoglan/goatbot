require File.dirname(__FILE__) + '/lib/goat/player'

board = ['nnaou'.split(''), 'mkhuu'.split(''), 'ifnfg'.split(''), 'baurn'.split(''), 'cruil'.split('')]
board_state = [[nil,nil,nil,nil,nil], [nil,nil,nil,nil,nil], [nil,nil,nil,nil,nil], [nil,nil,nil,nil,nil], [nil,nil,nil,nil,nil]]
last_move = []

p = Player.new
p.board = board
10.times do
   p.pick
end
