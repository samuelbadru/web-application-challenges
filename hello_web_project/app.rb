require 'sinatra/base'
require 'sinatra/reloader'

class Application < Sinatra::Base
  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
    register Sinatra::Reloader
  end

  get '/names' do
    "Julia, Mary, Karim"
  end
  
  get '/hello' do
    #name = params[:name]
    #"Hello #{name}"
    return erb(:index)
  end

  post '/sort-names' do
    names = params[:names].split(',').sort.join(',')
  end

  post '/submit' do
    name = params[:name]; message = params[:message]
    "Thanks #{name}, you sent this message: \"#{message}\""
  end
end