require 'sqlite3'
require 'csv'
require 'mini-levenshtein'

class ReaderService
    TABLE_NAME = "metadata_items"

    def self.call(csv, db_path)
        new(csv, db_path).check_missing_from_plex
    end

    def initialize(csv, db_path)
        @csv = csv
        @db_path = db_path
    end

    def check_missing_from_plex
        @titles = retrieve_titles_from_db
        parse_csv
    end

    private

    def retrieve_titles_from_db
        begin
        # Connect to the database
            @db = SQLite3::Database.new(@db_path)
            @db.execute("SELECT title FROM #{TABLE_NAME}").map { |row| row[0].downcase }
        rescue Exception => e
            puts "Error reading DB: #{e.message}"
            exit 1
        end
    end

    def parse_csv(accuracy = 0.95)
        missing = []
        begin
            CSV.foreach(@csv, headers: false) do |row|
                found = false
                downcased = row[0].downcase
                @titles.each do |title|
                    if MiniLevenshtein.similarity(downcased, title) > accuracy
                        found = true
                        break
                    end
                end
                if !found
                    missing << row[0]
                end
                found = false
            end
        rescue Exception => e
            puts "Error parsing CSV: #{e.message}"
            exit 1
        end
        missing
    end
end