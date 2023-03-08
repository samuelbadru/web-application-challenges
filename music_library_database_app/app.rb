# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  
  get '/albums' do
    albums = AlbumRepository.new
    @all_albums = albums.all
    return erb(:albums)
  end

  get '/albums/new' do
    return erb(:albums_new)
  end

  get '/albums/:id' do
    album_id = params[:id]
    albums = AlbumRepository.new
    selected_album = albums.find(album_id)
    @title = selected_album.title
    @year = selected_album.release_year
    artist_id = selected_album.artist_id
    
    artists = ArtistRepository.new
    selected_artist = artists.find(artist_id)
    @artist = selected_artist.name
    return erb(:index)
  end

  get '/artists' do
    repo = ArtistRepository.new
    @all_artists = repo.all
    return erb(:artists)
  end

  get '/artists/new' do
    return erb(:artists_new)
  end

  get '/artists/:id' do
    artist_id = params[:id]
    artists = ArtistRepository.new
    selected_artist = artists.find(artist_id)
    @name = selected_artist.name
    @genre = selected_artist.genre
    return erb(:artist)
  end

  post '/albums' do
    def invalid_request_parameters?
      # Are the params nil?
      return true if params[:title] == nil || params[:release_year] == nil || params[:artist_id] == nil 
    
      # Are they empty strings?
      return true if params[:title] == "" || params[:release_year] == "" || params[:artist_id] == ""
    
      return false
    end  
    
    if invalid_request_parameters?
      status 400
      return ''
    end

    new_album = Album.new
    new_album.title = params[:title]
    new_album.release_year = params[:release_year]
    new_album.artist_id = params[:artist_id]

    albums = AlbumRepository.new
    albums.create(new_album)
    return erb(:albums_new_post)
  end

  post '/artists' do
    def invalid_request_parameters?
      # Are the params nil?
      return true if params[:name] == nil || params[:genre] == nil
    
      # Are they empty strings?
      return true if params[:name] == "" || params[:genre] == ""
    
      return false
    end
    
    if invalid_request_parameters?
      status 400
      return ''
    end

    new_artist = Artist.new
    new_artist.name = params[:name]
    new_artist.genre = params[:genre]

    repo = ArtistRepository.new
    repo.create(new_artist)
    return erb(:artists_new_post)
  end

end