class Goat
  class Net
    include EM::Deferrable

    attr_accessor :username

    def initialize(agent, host, port)
      @agent = agent
      @host  = host
      @port  = port

      connect
    end

    def send_name(username)
      callback { @conn.send_data(username + "\n") }
    end

    def parse_line(line)
      parts = line.split(';').map(&:strip)
      puts "INFO #{parts.first}" unless parts.first == ''

      if parts.first =~ /new game/
        @agent.start_game
      end

      if parts[1] =~ /\?$/
        command = parts[1].split(/\s+/)
        case command.first
        when 'name' then @agent.ask_for_name
        when 'ping' then @conn.send_data("pong\n")
        when 'move' then process_move(command[1..-1])
        end
      end
    end

  private

    def process_move(move_data)
      letters = move_data[0..4].map { |s| s.scan(/./) }

      owners  = move_data[5..9].map do |s|
        s.scan(/./).map { |c| c == '0' ? nil : c.to_i }
      end

      @agent.update_letters(letters)
      @agent.update_ownership(owners)
      next_move = @agent.ask_for_move

      if next_move
        move_str = next_move.map { |p| p * '' } * ','
        callback { @conn.send_data("move:#{move_str}\n") }
      else
        callback { @conn.send_data("pass\n") }
      end
    end

    def connect
      EM.connect(@host, @port, Connection) do |conn|
        @conn = conn
        @conn.parent = self
        succeed
      end
    end

    class Connection < EM::Connection
      attr_accessor :parent

      def initialize(*args)
        super
        @buffer = ''
      end

      def receive_data(data)
        data.split("\n").each &@parent.method(:parse_line)
      end
    end

  end
end

