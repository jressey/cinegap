require 'mini-levenshtein'

class CheckMissingTitlesService

    def self.call(checkable_titles, existing_titles, accuracy = 0.8)
        new(checkable_titles, existing_titles, accuracy).call()
    end

    def initialize(checkable_titles, existing_titles, accuracy)
        @checkable_titles = checkable_titles
        @existing_titles = existing_titles
        @accuracy = accuracy
    end

    def call()
        missing = []
        @checkable_titles.each do |checkable_title|
            found = false
            checkable_title.downcase!
            @existing_titles.each do |existing_title|
                existing_title.downcase!
                if MiniLevenshtein.similarity(checkable_title, existing_title) > @accuracy
                    found = true
                    break
                end
            end
            if !found
                missing << checkable_title
            end
            found = false
        end
        missing
    end
end