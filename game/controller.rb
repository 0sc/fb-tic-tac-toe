require_relative "templates"
require_relative "setup"

module Game
  class Controller
    MARKS = %w[X O].freeze
    attr_reader :user, :cpu, :board, :engine, :request

    def self.new_game(request, user_mark)
      cpu_mark = (MARKS - [user_mark]).first
      user_psid = request.sender["id"]
      user, cpu, board, engine = Setup.new_game(user_psid, user_mark, cpu_mark)
      new(user, cpu, board, engine, request)
    end

    def self.resume_game(request)
      user_psid = request.sender["id"]
      user, cpu, board, engine = Setup.resume_game(user_psid)
      new(user, cpu, board, engine, request)
    end

    def initialize(user, cpu, board, engine, request)
      @user = user
      @cpu = cpu
      @board = board
      @engine = engine
      @request = request
    end

    def start(input = nil)
      # check game session is valid
      return invalid_game_session unless valid_game_session?

      engine.request = request
      continue = true
      continue = engine.validate_play(user, board, input) unless input.nil?

      return unless continue && !engine.game_over?(board)

      if input.nil? && user.mark == MARKS.first # user plays first
        send_image(board.display, request)
        engine.play(user, cpu, board)
      else # CPU plays first
        engine.play(cpu, user, board)
      end
    end

    private

    def invalid_game_session
      request.reply(text: "No active games found :(")
      send_choose_marker_prompt(request)
    end

    def valid_game_session?
      [user, cpu, board, engine].none?(&:nil?)
    end
  end
end
