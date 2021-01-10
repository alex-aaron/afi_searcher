
class CommandLineInterface

    BASE_PATH = "https://www.afi.com/afis-100-years-100-movies-10th-anniversary-edition/"
  
    def call 
      Scraper.new.scrape_afi(BASE_PATH)
      user_input = ""
      while user_input != "exit"
        puts "Heyyyyy, youuuuu guys! Welcome to the AFI's Top 100 sorter."
        puts "To see the entire list of films from 1 to 100, enter 'see top 100'"
        puts "To see films from a certain director, enter 'sort by director'"
        puts "To see every film with a certain actor, enter 'sort by actor'"
        puts "To see every film of a certain screenwriter, enter 'sort by writer'"
        puts "To see every film by a certain cinematographer, enter 'sort by cinematographer'"
        puts "To see every film by a certain editor, enter 'sort by editor'"
        puts "To see every film by a certain producer, enter 'sort by producer'"
        puts "To see every film from a certain production company, enter 'sort by production company'"
        puts "To the the details of an individual film, enter 'see film'"
        puts "To quit, enter 'exit'"
        user_input = gets.chomp
        case user_input
          when "see top 100"
              print_list
          when "sort by director"
              display_by_director
          when "sort by actor"
              display_by_cast_member
          when "sort by writer"
              display_by_writer
          when "sort by cinematographer"
              display_by_cinematographer
          when "sort by editor"
              display_by_editor
          when "sort by producer"
              display_by_producer
          when "sort by production company"
              display_by_production_company
          when "see film"
            display_individual_movie
          end
      end
    end
  
    def print_list
      puts "Lists, uh, find a way"
      Movies.all.each do |movie|
        puts "#{movie.rank}. #{movie.title} - #{movie.year}"
      end
    end
  
    def display_by_director
      count = 0
      puts "Mr. DeMille, I'm ready for my close-up! Seriously though, which director would you like to search for?"
      user_input = gets.chomp
      puts "#{user_input} films:"
      Movies.all.each do |movie|
        if movie.directors != nil
          if movie.directors.include?(user_input)
           puts "#{movie.rank}. #{movie.title} - #{movie.year}"
           count += 1
          end
        end
      end
      if count == 0
        puts "There are no films by that director."
      end    
    end
  
    def display_by_cast_member
      count = 0
      puts "Which actor's films would you like to search for?"
      user_input = gets.chomp
      puts "#{user_input} films:"
      Movies.all.each do |movie|
        if movie.cast != nil
          if movie.cast.include?(user_input)
            puts "#{movie.rank}. #{movie.title} - #{movie.year}"
            count += 1
          end
        end
      end
      if count == 0
        puts "There are no films with that actor."
      end
    end
  
    def display_by_writer
      count = 0
      puts "Which screenwriter would you like to search for?"
      user_input = gets.chomp
      puts "Films written by #{user_input}:"
      Movies.all.each do |movie|
        if movie.writer != nil
          if movie.writer.include?(user_input)
            puts "#{movie.rank}. #{movie.title} - #{movie.year}"
            count += 1
          end
        end
      end
      if count == 0
        puts "There are no films written by #{user_input}."
      end
    end
  
    def display_by_producer
      count = 0
      puts "Which producer would you like to search for?"
      user_input = gets.chomp
      puts "Films produced by #{user_input}:"
      Movies.all.each do |movie|
        if movie.producer != nil
          if movie.producer.include?(user_input)
            puts "#{movie.rank}. #{movie.title} - #{movie.year}"
            count += 1
          end
        end
      end
      if count == 0
        puts "There are no films produced by #{user_input}"
      end
    end
  
    def display_by_editor
      count = 0
      puts "Which editor would you like to search for?"
      user_input = gets.chomp
      puts "Films edited by #{user_input}:"
      Movies.all.each do |movie|
        if movie.editor != nil
          if movie.editor.include?(user_input)
            puts "#{movie.rank}. #{movie.title} - #{movie.year}"
            count += 1
          end
        end
      end
      if count == 0
        puts "There are no films edited by #{user_input}"
      end
    end
  
    def display_by_cinematographer
      count = 0
      puts "Which cinematographer would you like to search for?"
      user_input = gets.chomp
      puts "Films lensed by #{user_input}:"
      Movies.all.each do |movie|
        if movie.cinematographer != nil
          if movie.cinematographer.include?(user_input)
            puts "#{movie.rank}. #{movie.title} - #{movie.year}"
            count += 1
          end
        end
      end
      if count == 0
        puts "There are no films lensed by #{user_input}"
      end
    end
  
    def display_by_production_company
      count = 0
      puts "Which production company would you like to search for?"
      user_input = gets.chomp
      puts "Films produced by #{user_input}:"
      Movies.all.each do |movie|
        if movie.production_company != nil
          if movie.production_company.include?(user_input)
            puts "#{movie.rank}. #{movie.title} - #{movie.year}"
            count += 1
          end
        end
      end
      if count == 0
        puts "No films produced by #{user_input}"
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
            puts %Q(
            Director: #{movie.directors}
            Writer: #{movie.writer}
            Producer: #{movie.producer}
            Cast: #{movie.cast}
            Cinematographer: #{movie.cinematographer}
            Editor: #{movie.editor}
            Production Company: #{movie.production_company}
            )
          end
        end
      end
    end
  
    ########## HELPER FUNCTIONS ############
  end