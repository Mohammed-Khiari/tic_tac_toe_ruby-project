require_relative 'display.rb'

class Game
  include Display
  attr_reader :first_player, :second_player, :board, :current_player

  def initialize 
    @board = Board.new
    @first_player = nil
    @second_player = nil
    @current_player = nil
  end

  def play
    game_set_up
    board.show
    player_turns
    conlusion
  end

  def player_turns
    @current_player = first_player
    until board.full?
      turn(current_player)
      break if board.game_over?

      @current_player = switch_current_player
    end
  end

  def switch_current_player
    if current_player == first_player
      second_player  
    else
      first_player
    end
  end

  def turn(player)
    cell = turn_input(player)
    board.update_board(cell - 1, player.symbol) 
    board.show
  end

  def turn_input(player)
    puts "#{player.name}, please enter a number (1-9) that is available to place an '#{player.symbol}'"
    number = gets.chomp.to_i
    return number if board.valid_move?(number)

    puts display_input_warning
    turn_input(player)
  end 

  def game_set_up
    puts "Let's play a simple Tic-Tac-Toe game in the console! \n\n"
    @first_player = create_player(1)
    @second_player = create_player(2, first_player.symbol)
  end

  def create_player(number, duplicate_symbol = nil)
    puts "What is the name of player ##{number}?"
    name = gets.chomp
    symbol = symbol_input(duplicate_symbol)
    Player.new(name, symbol) 
  end

  def symbol_input(duplicate)
    player_symbol_prompts(duplicate)
    input = gets.chomp
    return input if input.match?(/^[^0-9]$/) && input != duplicate

    puts display_input_warning
    symbol_input(duplicate)
  end

  def player_symbol_prompts(duplicate)
    puts 'What 1 letter (or special character) would you like to be your game marker?'
    puts "It can not be '#{duplicate}'" if duplicate
  end

  def conlusion
    if board.game_over?
      puts "GAME OVER! #{current_player.name} is the winner!"
    else
      puts "It's a draw"
    end
  end
end