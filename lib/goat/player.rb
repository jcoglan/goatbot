class Player
  attr_writer :state, :board, :my_number

  def initialize
    @selected_words = []
  end

  def letters
    @letters ||= @board.flatten
  end

  def board=(b)
    @board = b
  end

  def pick
    selected_word = nil
    5.times do |num|
      selected_word = possible_words(5-num).first
      break if selected_word
    end
    if selected_word
      @selected_words << selected_word
      move = {}
      selected_word.each_with_index do |word_letter, word_index|
        @board.each_with_index do |row, i|
          row.each_with_index do |board_letter, j|
            if board_letter == word_letter && !move.values.include?([i,j])
              move[word_index] = [i, j]
            end
          end
        end
      end

      tiles = move.sort_by {|k,_|k}.map {|l| l.last}
      #tiles.each do |r,l|
      #  p @board[r][l]
      #end
      #puts ''
      return tiles
    else
      return nil
    end
  end

  def possible_words(num)
    @possible_words ||= []
    while word = brain.shift
      used_letters = letters.dup
      found = 0
      word.each do |l|
        if used_letters.include?(l)
          found += 1
          used_letters.delete(l)
        else
          break
        end
      end
      if found == word.size && !@selected_words.include?(word)
        @possible_words << word
        break if word.size >= num
      end
    end
    return @possible_words.sort_by {|w| w.size}.reverse
  end

  def brain
    @words ||= File.open('/usr/share/dict/words').readlines.map {|w| w.strip}.select { |w| w.size > 1 }.select {|w| w.downcase == w}.map {|w| w.split('')}
  end
end

