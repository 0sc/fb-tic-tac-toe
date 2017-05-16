#----------------------------------------------
# TicTacToe game in Ruby Language
# author: [Sanosh Wadghule, santosh.wadghule@gmail.com]
# copyright: (c) 2011 Santosh Wadghule
# git@github.com:mechanicles/ruby-tictactoe.git
#----------------------------------------------

require_relative "./board"
require_relative "./player"
require_relative "./templates"

module Game
  class Engine
    POSITION = %w[1 2 3 4 5 6 7 8 9].freeze

    attr_accessor :request

    def validate_play(current_player, board, position)
      if !POSITION.include?(position)
        request.reply(text: "Invalid input, Please choose number between 1 to 9")
        false
      elsif %w[X O].include?board.positions_with_values[position]
        request.reply(text: "Position already occupied, Please choose another number...")
        false
      else
        this = self
        current_player.move(board, position, self) { |url| send_image(url, this.request) }
        true
      end
    end

    def play(player1, player2, board)
      current_player = player1
      until game_over?(board) do
        if current_player.type == :user
          Setup.save_game(request.sender["id"], board)
          request.reply(text: "Your turn. Where do you want to move? <1-9>:")
          return
        else
          this = self
          request.reply(text: "Okay, my turn ...")
          # request.typing_on
          current_player.best_move(board) { |url| send_image(url, this.request) }
          display_winner(current_player.type) if check_winner(board)
          return if @game_over
          current_player = player2
        end
      end

      end_draw_game(board)
    end

    def check_winner(board)
      x_count = 0
      o_count = 0
      Board::WINNING_PLACES.each do |winning_place|
        winning_place.each do |index|
          if board.positions_with_values["#{index}"] == "X"
            x_count = x_count + 1
          elsif board.positions_with_values["#{index}"] == "O"
            o_count = o_count + 1
          end
        end
        if x_count == 3 or o_count == 3
          break
        else
          x_count = 0
          o_count = 0
        end
      end
      if x_count == 3
        return "X won"
      elsif o_count == 3
        return "O won"
      end
      return
    end

    def display_winner(type)
      if type == :user
        request.reply(text: "Congratulation!!!, you won the game")
      else
        request.reply(text: "Sorry, you lost the game :(")
      end
      Setup.end_game(request.sender["id"])
      @game_over = true
    end

    def game_over?(board)
      @game_over || board.positions_with_values.values.none?(&:empty?)
    end

    def end_draw_game(board)
      Setup.end_game(request.sender["id"])
      request.reply(text: "Game is a draw. Nice")
      send_image(board.display, request)
    end
  end
end
