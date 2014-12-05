require 'json'

class SongsController < ApplicationController
  before_filter :set_current_user

  def search_by_genre
    @searched_term = params[:search_term]
    if (@searched_term == nil) || (@searched_term.blank? == true)
      flash[:notice] = "Invalid search term"
      redirect_to sessions_path
    else
      if GENRES.include? @searched_term.downcase
        @search_message = "The following #{@searched_term} songs were found"
      else
        @search_message = "The following songs by #{@searched_term.split.map(&:capitalize).join(' ')} were found"
      end

      @songs = []
      @json_songs = []
      client = SoundCloud.new(:client_id => 'd2e2927d267c9beb15ad51ad98e897c6')
      tracks = client.get('/tracks', :limit => 30,:genres => @searched_term, :order => 'created_at')
      tracks.each do |track|
        if track.stream_url
          songs_hash = {}
          songs_hash[:track] = track
          songs_hash[:artwork] = track.artwork_url
          songs_hash[:title] = track.title
          songs_hash[:username] = track.user.username
          songs_hash[:url] = track.permalink_url
          songs_hash[:stream_url] = track.stream_url + '?client_id=d2e2927d267c9beb15ad51ad98e897c6'
          @songs.push(songs_hash)
          @json_songs.push(songs_hash.to_json)
        end
      end

      if tracks.count == 0
	      flash[:notice] = "No matching songs were found on Soundcloud"
        redirect_to sessions_path
      end
    end
  end
end
