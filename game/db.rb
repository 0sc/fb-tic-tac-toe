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
  end
end
