require "pg"

module Game
  class Db
    def self.exec_prepared_query(query, args)
      conn = connect
      conn.prepare("stmt", query)
      conn.exec_prepared("stmt", args) do |result|
        if block_given?
          result.each { |row| yield row }
        end
      end
      conn.close
    end

    def self.connect
      PG.connect(ENV["DATABASE_URL"])
    end

    def self.setup
      query = <<-SQL
        CREATE TABLE IF NOT EXISTS games (
          id SERIAL PRIMARY KEY,
          user_psid varchar(100) NOT NULL UNIQUE,
          user_mark varchar(1) NOT NULL,
          cpu_mark varchar(1) NOT NULL,
          board_state json,
          active bool NOT NULL
       );
      SQL
      connect.exec(query)
      connect.close
    end
  end
end
