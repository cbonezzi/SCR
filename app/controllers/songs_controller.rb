require "json"

class SongsController < ApplicationController
  before_filter :set_current_user

  def search
    @searched_term = session[:search_term]
    @similar_artists = []
    if params[:search_term]
      @searched_term = params[:search_term]
    end
    if @searched_term == nil || @searched_term.blank?
      flash[:notice] = "Invalid search term"
      redirect_to home_path
    else
      if GENRES.include? @searched_term.downcase
        @search_message = "Currently playing the #{@searched_term} radio"
      else
        @search_message = "Currently playing #{@searched_term.split.map(&:capitalize).join(" ")}'s playlist"
        @similar_artists = search_similar_artists(@searched_term)
      end

      @songs = []
      @json_songs = []
      @songs, @json_songs = search_random_songs(:genres, 30, 71, @searched_term)
      if not @similar_artists.empty?
        session[:search_term] = @searched_term
      end

      if @songs.empty?
	      flash[:notice] = "No matching songs were found on Soundcloud"
        redirect_to home_path
      end
    end
  end

  def search_random_songs(category, amount, offset, searched_term)
    client = SoundCloud.new(:client_id => @sc_api_client_id)
    songs = client.get("/tracks",
                        :limit => amount,
                        category => searched_term,
                        :order => "created_at",
                        :offset => rand(offset))
    songs.shuffle!
    songs_hashes = []
    json_songs = []
    songs.each do |song|
      if song.stream_url
        song_hash = {}
        if song.artwork_url.blank?
          song_hash[:artwork] = "/assets/audio.png"
        else
          song_hash[:artwork] = song.artwork_url
        end
        song_hash[:title] = song.title
        song_hash[:track] = song
        song_hash[:url] = song.permalink_url
        song_hash[:username] = song.user.username
        song_hash[:stream_url] = song.stream_url + "?client_id=" + @sc_api_client_id
        songs_hashes.push(song_hash)
        json_songs.push(song_hash.to_json)
      end
    end
    return songs_hashes, json_songs
  end

  def search_similar_artists(artist)
    similar_artists = []
    url = URI.parse("http://ws.audioscrobbler.com/2.0/?method=artist.getsimilar&artist=" + CGI.escape(artist.downcase) + "&api_key=" + @lfm_api_key + "&format=json")
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) { |http|
      http.request(req)
    }
    result = JSON.parse(res.body)
    if result.has_key?("error")
      similar_artists
    elsif result["similarartists"]["artist"] == artist
      similar_artists
    else
      counter = 0
      if result["similarartists"]["artist"].kind_of?(Array)
        result["similarartists"]["artist"].each do |artist_hash|
          similar_artists << artist_hash["name"]
          counter += 1
          if counter == 5
            break
          end
        end
      end
      similar_artists
    end
  end

  def create_station
    @searched_term = session[:search_term]
    @search_message = "Currently playing #{@searched_term.split.map(&:capitalize).join(" ")}'s radio"
    @similar_artists = search_similar_artists(@searched_term)
    @songs = []
    @json_songs = []
    @similar_artists.each do |artist|
      songs, json_songs = search_random_songs(:genres, 5, 1, artist)
      @songs += songs
    end
    songs, json_songs = search_random_songs(:genres, 10, 1, @searched_term)
    @songs += songs
    @songs.shuffle!
    @songs.each do |song|
        @json_songs.push(song.to_json)
    end
  end
end
