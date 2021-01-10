
class Scraper

    def scrape_afi(website)
  
      url = Nokogiri::HTML(open(website))
      movies = url.css("div.movie_popup.single_list")
      movie_hash_array = []
      movies.each do |listing|
        movie_hash = {}
        individual_ranking = listing.css("div.m_head").text.strip.split(" ")
        rank = individual_ranking.shift.gsub('.', "").to_i
        year = individual_ranking.pop.gsub("(", "").gsub(")", "")
        title = individual_ranking.join(" ")
        movie_hash[:rank] = rank
        movie_hash[:title] = title
        movie_hash[:year] = year
        additional_info = listing.css("div.col-sm-6 p")
        additional_info.each_with_index do |detail|
          detail_array = detail.text.split(": ")
          if detail_array[0] == "Production Company"
            movie_hash[:production_company] = detail_array[1]
          else
            movie_hash[detail_array[0].downcase.strip.to_sym] = detail_array[1]
          end
        end
        Movies.new(movie_hash)
        movie_hash_array << movie_hash
      end
      movie_hash_array
    end
  end