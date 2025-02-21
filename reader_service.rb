require 'sqlite3'
require 'csv'

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

    def self.parse_csv(csv, titles)
        missing = []
        begin
            CSV.foreach(csv, headers: false) do |row|
                if !titles.include? row[0].downcase
                    missing << row[0]
                end
            end
        rescue Exception => e
            puts "Error parsing CSV: #{e.message}"
            exit 1
        end
        missing
    end
end