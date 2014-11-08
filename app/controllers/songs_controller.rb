class SongsController < ApplicationController
  before_filter :set_current_user

  def search_by_genre
    if (params[:search_term] == nil) || (params[:search_term].blank? == true)
      flash[:notice] = "Invalid search term"
      redirect_to sessions_path
    else
      @searched_term = params[:search_term]
      client = SoundCloud.new(:client_id => 'd2e2927d267c9beb15ad51ad98e897c6')
      @song_titles_by_genre = []
      @songs_info = Array.new
      tracks = client.get('/tracks', :limit => 5,:genres => @searched_term, :order => 'hotness')
      tracks.each do |track|
        songs_hash = Hash.new
	songs_hash[:title] = track.title
        songs_hash[:username] = track.user.username
        embed_info = client.get('/oembed',  :url => track.permalink_url)
        songs_hash[:url] = embed_info['html'][71..-12]
        @songs_info.push(songs_hash)
        @song_titles_by_genre.push(track.title)
      end

      if tracks.count == 0
	flash[:notice] = "No matching songs were found on Soundcloud"
        redirect_to sessions_path
      end
    end
  end
end
