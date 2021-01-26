require 'pry'
class CommandLineInterface

    BASE_PATH = "https://www.afi.com/afis-100-years-100-movies-10th-anniversary-edition/"


    def call 
      Scraper.new.scrape_afi(BASE_PATH)
      user_input = ""
      while user_input != "exit"
        print_welcome_statement
        print_display_options
        print_sort_options
        user_input = gets.chomp
        case user_input
          when "see top 100"
              print_list
          when "directors"
              sort_by_user_input(user_input)
          when "cast"
              sort_by_user_input(user_input)
          when "writer"
              sort_by_user_input(user_input) 
          when "cinematographer"
              sort_by_user_input(user_input)
          when "editor"
              sort_by_user_input(user_input)
          when "producer"
              sort_by_user_input(user_input)
          when "production company"
              sort_by_user_input(user_input)
          when "see film"
            display_individual_movie
          when "sort by year"
            sort_by_year
          when "sort by decade"
            sort_by_decade
          when "see artists"
            display_by_category
          when "create directors hash"
            create_most_films_by_artist_hash("directors")
          when "most credited"
            most_credited_artist
          end
      end
    end

    def print_welcome_statement
      puts "Welcome to the AFI Top 100 Films sorter!"
    end

    def print_display_options
      puts %Q(
        Here are your options:
                                 DISPLAY OPTIONS
        - To see the entire list of films from 1 to 100, enter 'see top 100'
        - To see the details of an individual film, enter 'see film'
        - To see a lists of artists or production companies involved, enter 'see artists')
    end

    def print_sort_options
      puts %Q(
                                  SORT OPTIONS
        - To see every film from a certain director, enter 'directors'
        - To see every film with a certain actor, enter 'cast'
        - To see every film from a certain writer, enter 'writer'
        - To see every film by a certain cinematographer, enter 'cinematographer'
        - To see every film by a certain editor, enter 'editor'
        - To see every film by a certain producer, enter 'producer'
        - To see every film from a certain production company, enter 'production company'
        - To see every film from a particular year, enter 'sort by year'
        - To see every film from a particular decade, enter 'sort by decade'
        - To see the most credited artist for a certain category, enter 'most credited'

                          To quit at any time, enter 'exit'
      )
    end

    def print_list
      Movies.all.each do |movie|
        puts "#{movie.rank}. #{movie.title} - #{movie.year}"
      end
    end

    def display_individual_movie
      puts "Which film would you like to search for?"
      movie_title = gets.chomp.upcase
      movie = Movies.find_movie_by_title(movie_title)
      if movie.length > 0
        print_movie_details(movie[0])
      else
        puts %Q(
        "No movie matching that title."

        )
      end
    end

    def print_movie_details(movie_object)
      disciplines = [
        ["directors", "Director"], ["writer", "Writer"], ["cast", "Cast"], ["producer", "Producer"],
        ["cinematographer", "Cinematographer"], ["editor", "Editor"],["production_company", "Production Company"]
      ]
      puts "#{movie_object.rank}. #{movie_object.title} - #{movie_object.year}"
      disciplines.each do |discipline|
        if movie_object.send(discipline[0]) != nil
          if movie_object.send(discipline[0]).length > 1
            puts "  #{discipline[1]}: #{movie_object.send(discipline[0]).join(", ")}"
          else
            puts "  #{discipline[1]}: #{movie_object.send(discipline[0])[0]}"
          end
        end
      end
      puts ""
    end


    def display_by_category
      puts %Q(
        Select a category for which you would like to see a list of artists or entities:
        - To see a list of every director, enter 'directors'
        - To see a list of every actor, enter 'cast'
        - To see a list of every writer, enter 'writer'
        - To see a list of every producer, enter 'producer'
        - To see a list of every cinematographer, enter 'cinematographer'
        - To see a list of every editor, enter 'editor'
        - To see a list of every production companies, enter 'production company'
      )
      category_selection = gets.chomp
      if category_selection == "production company"
        category_selection = "production_company"
      end
      artist_array = Movies.find_all_artists_by_category(category_selection).uniq.sort!
      artist_array.each do |artist|
        puts artist
      end
    end

    def sort_by_user_input(sort_category)
      count = 0
      if sort_category == "cast"
        puts "Which actor would you like to search for?"
      else
        if sort_category == "production company"
          sort_category = "production_company"
        end
        puts "Which #{sort_category} would you like to search for?"
      end
      search_input = gets.chomp
      arr = Movies.find_movies_by_artist(sort_category, search_input)
      if arr.length == 0
        puts "There are no films matching that artist."
      else
        arr.each do |movie|
          puts movie
        end
      end
    end
  
    def sort_by_year
      puts "What year would you like to search for?"
      year = gets.chomp
      movies_by_year = Movies.find_movies_by_release_year(year)
      if movies_by_year.length > 0
        movies_by_year.each do |movie|
          puts "#{movie.rank}. #{movie.title} - #{movie.year}"
        end
      else
        puts "There were no movies in that year."
      end
    end

    def sort_by_decade
      puts "Which decade would you like to search for. Enter like this: 1990s"
      user_input = gets.chomp
      decade_array = Movies.find_movies_by_decade(user_input)
      if decade_array.length > 0
        decade_array.each do |movie|
          puts "#{movie.rank}. #{movie.title} - #{movie.year}"
        end
      else
        puts "There were no films from that decade"
      end
    end

    def most_credited_artist
      most_credited_array = []
      puts %Q(
      Options:
      - To find most credited director, enter 'directors'
      - To find most credited actor, enter 'cast'
      - To find most credited writer, enter 'writer'
      - To find most credited producer, enter 'producer
      - To find most credited cinematographer, enter 'cinematographer'
      - To find most credited editor, enter 'editor'
      - To find most credited production company enter 'production company'
      )
      artist_selection = gets.chomp
      if artist_selection == "production company"
        artist_selection = "production_company"
      end
      arr = Movies.find_all_artists_by_category(artist_selection)
      artist_hash = create_most_films_by_artist_hash(arr)
      max_credits = determine_max_number_of_credits(artist_hash)
      artist_hash.each do |key, value|
        if value == max_credits
          most_credited_array << key
        end
      end
      if most_credited_array.length > 1
        most_credited_array.each do |credit|
          print_by_name_and_category(credit, artist_selection, max_credits)
        end
      else
        print_by_name_and_category(most_credited_array[0], artist_selection, max_credits)
      end
    end

    def print_by_name_and_category(name, category, num_movies)
      puts "#{name} - #{num_movies} movies:"
      Movies.all.each do |movie|
        if movie.send(category) != nil
          movie.send(category).each do |credit|
            if credit.match(/#{name}/)
              puts "#{movie.rank}. #{movie.title} - #{movie.year}"
            end
          end
        end
      end
    end    

    
    def create_most_films_by_artist_hash(array)
      artist_hash = {}
      array.each do |artist|
        if artist_hash[artist] == nil
          artist_hash[artist] = 1
        else
          artist_hash[artist] = artist_hash[artist] + 1
        end
      end
      artist_hash
    end

    def collect_from_artist_hash(artist_hash, max_num)
      return_array = []
      artist_hash.each do |key, value|
        if value == max
          return_array << key
        end
      end
      return_array
    end

    def determine_max_number_of_credits(hash)
      max_num = hash.values.first
      hash.each do |key, value|
        if value >= max_num
          max_num = value
        end
      end
      max_num
    end

  end

