require 'net/http'
require 'nokogiri'


class PlexApiReaderService
    IP_ADDRESS = ENV["PLEX_IP_ADDRESS"]
    PLEX_TOKEN = ENV["PLEX_ACCESS_TOKEN"]

    def self.call()
        new().call()
    end

    def initialize(library_id = 1)
        @my_titles = []

        @library_id = library_id
    end

    def call()
        if !@library_id
            find_library
        end
        plex_movie_lookup_url = "http://#{IP_ADDRESS}/library/sections/#{@library_id}/all?X-Plex-Token=#{PLEX_TOKEN}"

        res = Net::HTTP.get(URI(plex_movie_lookup_url))
        doc = Nokogiri::XML(res)
        doc.xpath("MediaContainer//Video").each do |video_record|
            @my_titles << video_record['title']
        end
        @my_titles
    end

    def find_library
        # find library that looks like "movies"
        # get the location nested data
        # if location data is missing, id = 1
        plex_section_lookup_url = "http://#{ip_address}/library/sections/?X-Plex-Token=#{PLEX_TOKEN}"
        # hardcoded assumption
        # @library_id = some kind of parsing
    end
end