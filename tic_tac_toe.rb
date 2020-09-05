class Player
  attr_accessor :game, :name, :symbol
  def initialize(name,symbol)
    @name = name
    @symbol = symbol
  end

  def get_move(input_name)
    puts "\n#{name} Enter #{input_name}"
    gets.chomp.to_i
  end

  def move
    row = self.get_move("row")
    column = self.get_move("column")
    if @game.board[row][column] == "_"
      @game.board[row][column] = symbol
    else
      puts "\n Invalid Move Choice #{name}! Try Again!"
      self.move
    end
  end

  def add_game(game)
    @game = game
  end
end

class Game
  attr_accessor :players, :board

  def initialize
    @game_over = false
    @board = [['_','_','_'],['_','_','_'],['_','_','_']]
    @players = []
  end

  def end
    @game_over = true
  end

  def end?
    @game_over
  end

  def print_board
    puts "\n"
    @board.each { |i| p i }
  end

  def add_player(player)
    @players.push(player)
  end

  def check_for_game_over(board)
    
  end

  def play
    until @game_over
      @players.each do |player|
        self.print_board

        player.move
        break if @game_over
      end
    end
  end
end

player_1 = Player.new('Player 1', 'X')
player_2 = Player.new('Player 2', 'O')
match = Game.new

match.add_player(player_1)
match.add_player(player_2)
player_1.add_game(match)
player_2.add_game(match)
match.play

