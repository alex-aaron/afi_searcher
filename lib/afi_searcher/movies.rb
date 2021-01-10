
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
    
  end