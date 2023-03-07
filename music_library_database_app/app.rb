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

  get '/albums/:id' do
    album_id = params[:id]
    albums = AlbumRepository.new
    selected_album = albums.find(album_id)
    selected_album.title
  end

  get '/artists' do
    repo = ArtistRepository.new
    all_names = []
    all_artists = repo.all

    all_artists.each do |artist|
      all_names << artist.name
    end

    all_names.join(', ')
  end

  post '/albums' do
    new_album = Album.new
    new_album.title = params[:title]
    new_album.release_year = params[:release_year]
    new_album.artist_id = params[:artist_id]

    albums = AlbumRepository.new
    albums.create(new_album)
  end

  post '/artists' do
    new_artist = Artist.new
    new_artist.name = params[:name]
    new_artist.genre = params[:genre]

    repo = ArtistRepository.new
    repo.create(new_artist)
  end

end