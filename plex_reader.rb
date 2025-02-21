require_relative 'reader_service'

if ARGV.count != 1
    puts "Usage: ruby reader.rb <csv_file>"
    exit 1
end

csv = ARGV[0]
db_path = "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Plug-in Support/Databases/com.plexapp.plugins.library.db"

missing = ReaderService.check_missing_from_plex(csv, db_path)

missing.each { |title| puts title }
puts "=========================="
puts "You are missing #{missing.count} titles from this list, have you seen #{missing.sample}?"