
class Scraper

    def scrape_afi(website)
  
      url = Nokogiri::HTML(open(website))
      top_100 = url.css("div.movie_popup.single_list")
      movie_hash_array = []

      top_100.each do |movie|
        movie_hash = {}
        rank_year_title = grab_rank_year_title(movie)
        insert_rank_year_title_into_hash(movie_hash, rank_year_title)
        additional_info = movie.css("div.col-sm-6 p")
        
        additional_info.each_with_index do |detail|
          detail_array = detail.text.split(": ")
          if detail_array[0] == "Production Company"
            create_production_company_credit(movie_hash, detail_array)
          elsif detail_array[0] == "Cast"
            movie_hash[:cast] = detail_array[1].split(", ")
          else
            create_credits_with_ids(movie_hash, detail_array)
          end
        end

        Movies.new(movie_hash)
        movie_hash_array << movie_hash
      end
      movie_hash_array
    end

    def grab_rank_year_title(slot)
      movie_rank_title_year_array = []
      movie_rank_title_year = slot.css("div.m_head").text.strip.split(" ")
      rank = movie_rank_title_year.shift.gsub('.', "").to_i
      year = movie_rank_title_year.pop.gsub("(", "").gsub(")", "")
      title = movie_rank_title_year.join(" ")
      movie_rank_title_year_array << rank
      movie_rank_title_year_array << title
      movie_rank_title_year_array << year
      movie_rank_title_year_array
    end

    def insert_rank_year_title_into_hash(hash, array)
      hash[:rank] = array[0]
      hash[:title] = array[1]
      hash[:year] = array[2]
    end

    def create_production_company_credit(hash, array)
      production_company = array[1].split("., ")
      hash[:production_company] = production_company
    end

    def create_credits_with_ids(hash, array)
      final_credit_array = []
      credit_array = array[1].split("|")
      credit_array.each do |credit|
        if credit != "" && !credit.match(/\d/)
          final_credit_array << credit
        end 
      end
      hash[array[0].downcase.strip.to_sym] = final_credit_array
    end
  end