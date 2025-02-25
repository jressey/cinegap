require 'csv'

class CsvReaderService
    TABLE_NAME = "metadata_items"

    def self.call(csv)
        new(csv).call
    end

    def initialize(csv)
        @csv = csv
    end

    def call
        titles = []
        CSV.foreach(@csv, headers: false) do |row|
            titles << row[0].downcase
        end
        titles
    end
end