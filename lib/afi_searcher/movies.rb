require 'pry'
class Movies

    attr_accessor :rank, :title, :year, :cast, :directors, :producer, :writer, :editor, :cinematographer, :production_company
    
    @@all = []
  
    def initialize(movie_hash)
        movie_hash.each {|key, value| self.send(("#{key}="), value)}
        @@all << self
    end
  
    def self.all
      @@all
    end

    def self.find_movies_by_artist(category, artist_name)
      return_array = []
      Movies.all.each do |movie|
        if movie.send(category) != nil
          movie.send(category).each do |credit|
            if credit.match(/#{artist_name}/)
              listing = "#{movie.rank}. #{movie.title} - #{movie.year}"
              return_array << listing
            end
          end
        end
      end
      return_array
    end

    def self.find_movie_by_title(title)
      return_array = []
      Movies.all.each do |movie|
        if movie.title != nil
          if movie.title.include?(title)
            return_array << movie
          end
        end
      end
      return_array
    end

    def self.find_all_artists_by_category(category)
      return_array = []
      Movies.all.each do |movie|
        if movie.send(category) != nil
          movie.send(category).each do |credit|
            if self.has_guild_in_credit(credit)
              new_credit = self.remove_guild_from_credit(credit)
              return_array << new_credit
            else
              return_array << credit
            end
          end
        end
      end
      return_array
    end

    def self.find_movies_by_release_year(release_year)
      return_array = []
      Movies.all.each do |movie|
        if movie.year == release_year
          return_array << movie
        end
      end
      return_array
    end

    def self.find_movies_by_decade(decade)
      return_array = []
      decade_array = decade.split("")
      decade_search_term = decade_array[0] + decade_array[1] + decade_array[2]
      Movies.all.each do |movie|
        if movie.year.match(/#{decade_search_term}/)
          return_array << movie
        end
      end
      return_array
    end

    private
    def self.has_guild_in_credit(credit)
      if credit.match(/.\s[A-Z].[A-Z].[A-Z]/)
        credit_with_guild = credit
      end
      credit_with_guild
    end

    def self.remove_guild_from_credit(credit)
      separated_credit = credit.split(", ")
      credit_minus_guild = separated_credit[0].strip
      credit_minus_guild
    end
    
  end