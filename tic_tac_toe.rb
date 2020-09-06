# frozen_string_literal: true

# Player instances are the representations of each player
class Player
  attr_accessor :game, :name, :symbol
  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end

  def move
    puts "\n#{name} Enter Tile Choice"
    move_choice = gets.chomp.to_i - 1
    if valid_move?(move_choice)
      update_board(move_choice)
    else
      puts "\n Invalid Move Choice #{name}! Try Again!"
      move
    end
  end

  def add_game(game)
    @game = game
  end

  def unflatten(flat_array, sub_array_length)
    unflattend_array = []
    unflattend_array.push(flat_array.slice!(0...sub_array_length)) while \
    flat_array.size >= sub_array_length
    unflattend_array
  end

  def valid_move?(move_choice)
    @game.board.flatten[move_choice] == '_' && move_choice >= 0
  end

  def update_board(move_choice)
    @game.board.flatten![move_choice] = symbol
    @game.board = unflatten(@game.board, 3)
  end
end

# Game instances are the representation of the current match being played
class Game
  attr_accessor :players, :board

  def initialize
    @game_over = false
    @board = [%w[_ _ _], %w[_ _ _], %w[_ _ _]]
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
    if horizontal_win(board, player) ||
       vertical_win(board, player) ||
       diagonal_win(board, player)
      puts "\n #{player.name} Won!"
      true
    elsif tie(board)
      puts "\n Tie Game"
      true
    end
  end

  def horizontal_win(board, player)
    board.each { |row| return true if all_match_symbol(row, player) }
    false
  end

  def vertical_win(board, player)
    horizontal_win(board.transpose, player)
  end

  def diagonal_win(board, player)
    top_down_diagonal = [board[0][0], board[1][1], board[2][2]]
    bottom_up_diagonal = [board[0][2], board[1][1], board[2][0]]
    return true if all_match_symbol(top_down_diagonal, player) ||
                   all_match_symbol(bottom_up_diagonal, player)
  end

  def tie(board)
    return false if board.flatten.include?('_')

    true
  end

  def all_match_symbol(array, player)
    array.all? { |tile| tile == player.symbol }
  end

  def play
    until @game_over
      @players.each do |player|
        print_board
        player.move
        next unless game_over?(@board, player)

        print_board
        @game_over = true
        break
      end
    end
  end
end

first_player = Player.new('Player 1', 'X')
second_player = Player.new('Player 2', 'O')
match = Game.new

match.add_player(first_player)
match.add_player(second_player)
first_player.add_game(match)
second_player.add_game(match)
puts 'Use the numbers 1-9 to pick a tile, ordered from top left to bottom right'
puts 'Like this: '
p '1,2,3'
p '4,5,6'
p '7,8,9'
match.play
