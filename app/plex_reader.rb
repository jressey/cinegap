require_relative 'csv_reader_service'
require_relative 'reader_service'
require_relative 'plex_api_reader_service'
require_relative 'check_missing_titles_service'

if ARGV.count != 1
    puts "Usage: ruby reader.rb <csv_file>"
    exit 1
end

csv = ARGV[0]
checkable_titles = CsvReaderService.call(csv)

existing_titles = PlexApiReaderService.call()

missing_titles = CheckMissingTitlesService.call(checkable_titles, existing_titles)

if missing_titles.size == 0
    puts "You have all of the movies!"
else
    missing_titles.each { |title| puts title }
    puts "=========================="
    puts "You are missing #{missing_titles.count} titles from this list, have you seen #{missing_titles.sample}?"
end