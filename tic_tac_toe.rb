class Player
  attr_accessor :game, :name, :symbol
  def initialize(name,symbol)
    @name = name
    @symbol = symbol
  end

  def get_move
    puts "\n#{name} Enter Tile Choice"
    gets.chomp.to_i
  end

  def move
    move_choice = self.get_move.to_i - 1
    if @game.board.flatten[move_choice] == "_" && move_choice >= 0
      @game.board.flatten![move_choice] = symbol
      @game.board = unflatten(@game.board, 3)
    else
      puts "\n Invalid Move Choice #{name}! Try Again!"
      self.move
    end
  end

  def add_game(game)
    @game = game
  end

  def unflatten(flat_array, sub_array_length)
    unflattend_array = []
    while flat_array.size >= sub_array_length do
      unflattend_array.push(flat_array.slice!(0...sub_array_length))
    end
    unflattend_array
  end
end

class Game
  attr_accessor :players, :board

  def initialize
    @game_over = false
    @board = [['_','_','_'], ['_','_','_'], ['_','_','_']]
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

  def game_over?(board, player)
    true if horizontal_win(board, player)
    true if vertical_win(board, player)
  end

  def horizontal_win(board, player)
    board.each { |row| return true if row.all? {|tile| tile == player.symbol}} 
    false
  end

  def vertical_win(board, player)
    horizontal_win(board.transpose, player)
  end

  def play
    until @game_over
      @players.each do |player|
        self.print_board
        player.move
        if self.game_over?(@board, player)
          self.print_board
          puts "\n #{player.name} Won!"
          @game_over = true
          break
        end
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
puts "Use the numbers 1-9 to pick a tile, ordered from top left to bottom right"
puts "Like this: "
p "1,2,3"
p "4,5,6"
p "7,8,9"
match.play

