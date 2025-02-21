require_relative 'reader_service'

if ARGV.count != 2
    puts "Usage: ruby reader.rb <csv_file> <title_column_index>"
    exit 1
end

csv = ARGV[0]
db_path = ARGV[1]

missing = ReaderService.check_missing_from_plex(csv, db_path)

missing.each { |title| puts title }
puts "=========================="
puts "You are missing #{missing.count} titles from this list, have you seen #{missing.sample}?"