require "spec_helper"
require "rack/test"
require_relative '../../app'

def reset_albums_table
  seed_sql = File.read('spec/seeds/albums_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

def reset_artists_table
  seed_sql = File.read('spec/seeds/artists_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

describe Application do
  before(:each) do 
    reset_albums_table
    reset_artists_table
  end

  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "POST /albums" do
    it 'inserts the "Voyage" album into the albums table' do
      create_response = post('/albums', title: 'Voyage', release_year: '2022', artist_id: '2')

      expect(create_response.status).to eq(200)

      show_response = get('/albums/13')
      expect(show_response.status).to eq(200)
      expect(show_response.body).to eq('Voyage')
    end
  end

  context "GET /artists" do
    it 'gives a 200 status code' do
      artist_list_response = get('/artists')
      expect(artist_list_response.status).to eq (200)
    end
    
    it 'returns the list of artists' do
      artist_list_response = get('/artists')
      expect(artist_list_response.body).to eq ('Pixies, ABBA, Taylor Swift, Nina Simone')
    end
  end

  context "POST /artists" do
    it 'gives a 200 status code' do
      post_artists_response = post('/artists', name: 'Wild nothing', genre: 'Indie')
      expect(post_artists_response.status).to eq (200)
    end

    it 'adds the artist to the artists table' do
      post_artists_response = post('/artists', name: 'Wild nothing', genre: 'Indie')
      get_response = get('/artists')
      expect(get_response.body).to eq ('Pixies, ABBA, Taylor Swift, Nina Simone, Wild nothing')
    end
  end

end