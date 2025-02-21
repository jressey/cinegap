require 'sqlite3'
require 'csv'
require 'mini-levenshtein'

class ReaderService
    TABLE_NAME = "metadata_items"

    def self.check_missing_from_plex(csv, db_path)
        titles = self.read_db(db_path)
        self.parse_csv(csv, titles)
    end

    private

    def self.read_db(db_path)
        begin
        # Connect to the database
            db = SQLite3::Database.new(db_path)
            titles = db.execute("SELECT title FROM #{TABLE_NAME}").map { |row| row[0].downcase }
        rescue Exception => e
            puts "Error reading DB: #{e.message}"
            exit 1
        end
    end

    def self.parse_csv(csv, titles, accuracy = 0.95)
        missing = []
        begin
            CSV.foreach(csv, headers: false) do |row|
                found = false
                downcased = row[0].downcase
                titles.each do |title|
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