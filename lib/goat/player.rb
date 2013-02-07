class Player
  attr_writer :state, :board, :my_number

  def initialize
    @selected_words = []
  end

  def letters
    @letters ||= @board.flatten
  end

  def pick
    possible_words = []
    brain.each do |word, sorted_word|
      used_letters = letters.dup
      found = 0
      word.split('').each do |l|
        if used_letters.include?(l)
          found += 1
          used_letters.delete(l)
        end
      end
      if found == word.size
        possible_words << word
      end
    end

    possible_words = possible_words.sort_by { |w| w.size }
    selected_word = possible_words.reverse.detect {|word| !@selected_words.include?(word)}
    if selected_word
      @selected_words << selected_word
      move = {}
      selected_word.split('').each_with_index do |word_letter, word_index|
        @board.each_with_index do |row, i|
          row.each_with_index do |board_letter, j|
            if board_letter == word_letter && !move.values.include?([i,j])
              move[word_index] = [i, j]
            end
          end
        end
      end
      return move.values
    else
      return nil
    end
  end

  def brain
    @words ||= File.open('/usr/share/dict/words').readlines.map {|w| w.strip}.select { |w| w.size > 1 }.select {|w| w.downcase == w}
  end
end

