require_relative 'reader_service'
require_relative 'plex_api_reader_service'

if ARGV.count != 2
    puts "Usage: ruby reader.rb <csv_file> <use_api>"
    exit 1
end

csv = ARGV[0]
use_api = ARGV[1]
db_path = "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Plug-in Support/Databases/com.plexapp.plugins.library.db"

missing_titles = []
checkable_titles = ["Amadeus", "The Shining", "Fake Movie Title"]
my_titles = []
if use_api
    missing_titles = checkable_titles - PlexApiReaderService.call()
else
    missing_titles = ReaderService.call(csv, db_path)
end

if missing_titles.size == 0
    puts "You have all of the movies!"
else
    missing_titles.each { |title| puts title }
    puts "=========================="
    puts "You are missing #{missing_titles.count} titles from this list, have you seen #{missing_titles.sample}?"
end