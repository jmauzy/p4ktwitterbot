require 'nokogiri'
require 'open-uri'

class Review
  attr_accessor :title, :link, :artist, :genre, :type
  def initialize
    @type = nil
    @artist = nil
    @title = nil
    @link = nil
    @genre = nil
  end

  public
  def get_album
    set_values(".bnm/.review-block")
  end

  def get_track
    set_values(".track/.review-block")
  end

  private 
  
  def set_values(css)
    results = Nokogiri::HTML(open("http://pitchfork.com/best")).css(css)

    @artist = results.css(".artist-list").text
    @title = results.css(".title").text
    @link = "http://pitchfork.com#{results.css("a").attribute('href').to_s}"
    @genre = results.css(".genre-list").first.text
  end

end
