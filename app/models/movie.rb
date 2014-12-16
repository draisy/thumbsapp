class Movie < ActiveRecord::Base
  has_many :movie_reviews
  has_many :sentiments, through: :movie_reviews

  def self.find_or_create_movies
    bf = BadFruit.new('hk73sdh9btjw5w9t6m2cws9p')
    in_theaters = bf.lists.in_theaters
    in_theaters.each do |m|
      if !Movie.find_by(title: m.name)
        poster = get_poster(m.posters.thumbnail)
        movie = Movie.new(:title => m.name, :poster => poster)
          begin
            m.reviews.each do |r|
              movie.movie_reviews.build(:quote => r.quote)
            end
          rescue
            puts "ran out api calls"
          end
        movie.save
      end
    end
  end

  def self.get_poster(filename)
    filename.gsub('tmb', 'det')
  end

end

require 'httparty'
 
API_VERSION = "v1.0"
API_BASE_URL = "http://api.rottentomatoes.com/api/public/#{API_VERSION}"
LISTS_DETAIL_BASE_URL = "#{API_BASE_URL}/lists"
@api_key = 'hk73sdh9btjw5w9t6m2cws9p'
url = "#{LISTS_DETAIL_BASE_URL}/movies/in_theaters.json?apikey=#{@api_key}"
 
 
HTTParty.get(url)

