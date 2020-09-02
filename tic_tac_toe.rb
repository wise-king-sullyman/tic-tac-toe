class Player
  attr_accessor :game, :name, :symbol
  def initialize(name,symbol)
    @name = name
    @symbol = symbol
  end

  def play(symbol,row,column)
    @game.board[row][column] = symbol
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
    @board.each { |i| p i }
  end

  def add_players(player1, player2)
    @players.push(player1, player2)
  end
end

player_1 = Player.new('Player 1', 'X')
player_2 = Player.new('Player 2', 'O')
match = Game.new

match.add_players(player_1,player_2)
player_1.add_game(match)
player_2.add_game(match)

turn_count = 0 #0 for player1, 1 for player2
until match.end? == true

  puts "#{match.players[turn_count].name} Enter Move Row"
  row = gets.chomp.to_i
  puts "#{match.players[turn_count].name} Enter Move Column"
  column = gets.chomp.to_i
  #match.end if move == "end" 
  match.players[turn_count].play(match.players[turn_count].symbol,row,column)
  turn_count == 0 ? turn_count += 1 : turn_count -= 1
  match.print_board
  
end
