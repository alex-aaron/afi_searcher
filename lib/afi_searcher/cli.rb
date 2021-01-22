require 'pry'
class CommandLineInterface

    BASE_PATH = "https://www.afi.com/afis-100-years-100-movies-10th-anniversary-edition/"

    @@movie_attributes = ["cast", "cinematographer", "directors", "editor", "producer", "production_company", 
                          "rank", "title", "writer", "year"]

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
  ########################## DISPLAY METHODS ##########################

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
      count = 0
      puts "Which film would you like to search for?"
      user_input = gets.chomp.upcase
      Movies.all.each do |movie|
        if movie.title != nil
          if movie.title.include?(user_input)
             puts "#{movie.rank}. #{movie.title} - #{movie.year}"
             print_movie_details(movie, "directors", "Director")
             print_movie_details(movie, "writer", "Writer")
             print_movie_details(movie, "producer", "Producer")
             print_movie_details(movie, "cast", "Cast")
             print_movie_details(movie, "cinematographer", "Cinematographer")
             print_movie_details(movie, "editor", "Editor")
             print_movie_details(movie, "production_company", "Production Company")
             puts ""
          end
        end
      end
    end

    def print_movie_details(object, category, category_text)
      if object.send(category).length > 1
        puts "    #{category_text}: #{object.send(category).join(", ")}"
      else
        puts "    #{category_text}: #{object.send(category)[0]}"
      end
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
      artist_array = create_array_for_artist(category_selection).uniq.sort!
      artist_array.each do |artist|
        puts artist
      end
    end

    ##################### SORT METHODS #######################

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
      Movies.all.each do |movie|
        if movie.send(sort_category) != nil
          movie.send(sort_category).each do |credit|
            if credit.match(/#{search_input}/)
              puts "#{movie.rank}. #{movie.title} - #{movie.year}"
              count += 1
            end
          end
        end
      end
      if count == 0
        puts "There are no films matching that artist."
      end
    end
  
    def sort_by_year
      count = 0
      puts "What year would you like to search for?"
      user_input = gets.chomp
      Movies.all.each do |movie|
        if movie.year == user_input
          puts "#{movie.rank}. #{movie.title} - #{movie.year}"
          count +=1
        end
      end
      if count == 0
        puts "There were no films in the AFI top 100 from that year."
      end
    end

    def sort_by_decade
      puts "Which decade would you like to search for. Enter like this: 1990s"
      user_input = gets.chomp
      year_array = user_input.split("")
      decade_search = year_array[0] + year_array[1] + year_array[2]
      decade_array = []
      Movies.all.each do |movie|
        if movie.year.match(/#{decade_search}/)
          entry = "#{movie.rank}. #{movie.title} - #{movie.year}"
          decade_array << entry
        end
      end
      puts "#{decade_array.length} movies from the #{user_input}:"
      decade_array.each do |decade_movie|
        puts decade_movie
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
      arr = create_array_for_artist(artist_selection)
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
          #puts "#{credit} - #{max_credits} films"
        end
      else
        print_by_name_and_category(most_credited_array[0], artist_selection, max_credits)
        #puts "#{most_credited_array[0]} - #{max_credits} films"
      end
    end

    def print_by_name_and_category(name, category, num_movies)
      puts "#{name} - #{num_movies} movies:"
      Movies.all.each do |movie|
        if movie.send(category) != nil
          if movie.send(category).include?(name)
            puts "  #{movie.rank}. #{movie.title} - #{movie.year}"
          end
        end
      end
    end

    def create_array_for_artist(category)
      artist_array = []
      Movies.all.each do |movie|
        if movie.send(category) != nil
          if movie.send(category).length > 1
            movie.send(category).each do |credit|
              if credit.match(/.\s[A-Z].[A-Z].[A-Z]/)
                separated_credit = credit.split(", ")
                credit_minus_guild = separated_credit[0].strip
                artist_array << credit_minus_guild[0]
              else
                artist_array << credit
              end
            end
          else
            if movie.send(category)[0].match(/.\s[A-Z].[A-Z].[A-Z]/)
              separated_credit = movie.send(category)[0].split(", ")
              credit_minus_guild = separated_credit[0].strip
              artist_array << credit_minus_guild
            else
              artist_array << movie.send(category)[0]
            end
          end
        end
      end
      artist_array
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

