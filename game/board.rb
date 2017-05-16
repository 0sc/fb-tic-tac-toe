#----------------------------------------------
# TicTacToe game in Ruby Language
# author: [Sanosh Wadghule, santosh.wadghule@gmail.com]
# copyright: (c) 2011 Santosh Wadghule
# git@github.com:mechanicles/ruby-tictactoe.git
#----------------------------------------------

module Game
  class Board

    attr_accessor :info, :positions_with_values

    WINNING_PLACES = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]


    def initialize(val = nil, board_image) # board position starts from 1 to 9
      @positions_with_values = val || {"1" => "", "2" => "", "3" => "",
        "4" => "", "5" => "", "6" => "",
        "7" => "", "8" => "", "9" => ""}

      @board_image = board_image
      end

      def display
        # puts ""
        # puts " #{self.positions_with_values["1"]} | #{self.positions_with_values["2"]} | #{self.positions_with_values["3"]} "
        # puts "-----------"
        # puts " #{self.positions_with_values["4"]} | #{self.positions_with_values["5"]} | #{self.positions_with_values["6"]} "
        # puts "-----------"
        # puts " #{self.positions_with_values["7"]} | #{self.positions_with_values["8"]} | #{self.positions_with_values["9"]} "
        # puts ""

        @board_image.display(positions_with_values)
      end
    end
end
