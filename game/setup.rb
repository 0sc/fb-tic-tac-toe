require "json"
require "json/ext"

require_relative "db"
require_relative "player"
require_relative "board"
require_relative "engine"
require_relative "display"

module Game
  class Setup
    def self.new_game(user_psid, user_mark, cpu_mark)
      query = "INSERT INTO games (user_psid, user_mark, cpu_mark, board_state, active) " \
      "VALUES($1, $2, $3, $4, $5) " \
      "ON CONFLICT (user_psid) DO " \
      "UPDATE SET user_mark = $2, cpu_mark = $3, board_state = $4, active = $5"

      display = Display.new(user_mark, cpu_mark)
      board = Board.new(nil, display)
      args = [
        user_psid,
        user_mark,
        cpu_mark,
        board.positions_with_values.to_json,
        true
      ]

      Db.exec_prepared_query(query, args)

      [Player.new(user_mark), Player.new(cpu_mark, :cpu), board, Engine.new]
    end

    def self.resume_game(user_psid)
      record = []
      query = "SELECT * FROM games WHERE user_psid = $1 AND active = true"
      Db.exec_prepared_query(query, [user_psid]) do |game|
        display = Display.new(game["user_mark"], game["cpu_mark"])
        record << Player.new(game["user_mark"])
        record << Player.new(game["cpu_mark"], :cpu)
        record << Board.new(JSON.parse(game["board_state"]), display)
        record << Engine.new
      end
      record
    end

    def self.save_game(user_psid, board_state)
      query = "UPDATE games SET board_state = $1 WHERE user_psid = $2"
      Db.exec_prepared_query(
        query,
        [board_state.positions_with_values.to_json, user_psid]
      )
    end

    def self.end_game(user_psid)
      query = "UPDATE games SET active = false WHERE user_psid = $1"
      Db.exec_prepared_query(query, [user_psid])
    end
  end
end
