require_relative '../lib/Logger'
require_relative '../lib/Review'
require_relative '../lib/Tweet'

AppRoot = File.expand_path(File.dirname(__FILE__))
@log = File.join(AppRoot, '../log/tweets.log')

def check_albums
  album = Review.new
  album.get_album
  album.type = "ALBUM:"

  process_review(album)
end

def check_tracks
  track = Review.new
  track.get_track
  track.type = "TRACK:"

  process_review(track)
end

def process_review(review)
  if Logger.is_new?(@log, review.title) then 
    tweet_contents = generate_tweet_contents(review)
    new_tweet = Tweet.new(tweet_contents)
    new_tweet.tweet
    Logger.add(@log, review.title)
    puts tweet_contents
  else
    print '*'
  end
end

def generate_tweet_contents(review)
  @type = review.type
  @artist = review.artist
  @title = format_title(review.title)
  @genre = format_genre(review.genre)
  @link = review.link
  @artist_tag = hashtagger(review.artist)


  "#{@type} #{@artist} - #{@title}#{@genre}#{@artist_tag} #{@link}"
end

def format_genre(genre)
  if genre.empty?
    return " "
  else
    return " (#{genre}) "
  end
end

#removes non-ascii characters to fix nokogiri formatting
def format_title(title)
  title.gsub(/[\u0080-\u00ff]/, "")
end

def hashtagger(artist)
  "##{artist.gsub(/[^0-9a-z]/i, '')}"
end

while true do
  begin
  check_albums
  check_tracks
  rescue => error
    puts error
  end

  sleep(600)
end
