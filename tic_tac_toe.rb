# frozen_string_literal: true

# Module with one function, taking a flat array and making it "unflat"
module Unflatten
  def unflatten(flat_array, sub_array_length)
    unflattend_array = []
    unflattend_array.push(flat_array.slice!(0...sub_array_length)) while \
    flat_array.size >= sub_array_length
    unflattend_array
  end
end

# Player instances are the representations of each player
class Player
  attr_accessor :name, :symbol

  def initialize(name, symbol, game)
    @name = name
    @symbol = symbol
    @game = game
  end

  def move
    puts "\n#{name} Enter Tile Choice"
    move_choice = gets.chomp.to_i - 1
    if @game.valid_move?(move_choice)
      @game.update_board(move_choice, symbol)
    else
      puts "\n Invalid Move Choice #{name}! Try Again!"
      move
    end
  end
end

# Game instances are the representation of the current match being played
class Game
  include Unflatten

  def initialize
    @game_over = false
    @board = [%w[_ _ _], %w[_ _ _], %w[_ _ _]]
    @players = []
  end

  def add_player(player)
    @players.push(player)
  end

  def play
    until @game_over
      @players.each do |player|
        print_board
        player.move
        next unless game_over?(@board, player)

        print_board
        end_game
        break
      end
    end
  end

  def valid_move?(move_choice)
    @board.flatten[move_choice] == '_' && move_choice >= 0
  end

  def update_board(move_choice, symbol)
    @board.flatten![move_choice] = symbol
    @board = unflatten(@board, 3)
  end

  private

  def end_game
    @game_over = true
  end

  def print_board
    puts "\n"
    @board.each { |i| p i }
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
end

quit_playing = false

until quit_playing
  match = Game.new
  first_player = Player.new('Player 1', 'X', match)
  second_player = Player.new('Player 2', 'O', match)

  match.add_player(first_player)
  match.add_player(second_player)

  puts 'Use the numbers 1-9 to pick a tile, ordered from top left to bottom right'
  puts 'Like this: '
  p %w[1 2 3]
  p %w[4 5 6]
  p %w[7 8 9]

  match.play

  puts "\n Hit 'Enter' to Play again. Type 'stop' to quit."
  next unless gets.chomp == 'stop'

  quit_playing = true
end
