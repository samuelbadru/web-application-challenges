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

  context "GET /albums" do
    before do
      @albums_response = get('/albums')
    end

    it 'is a valid web query' do
      expect(@albums_response.status).to eq (200)
    end

    it 'has "Albums" as a heading' do
      expect(@albums_response.body).to include('<h1>Albums</h1>')
    end

    it 'returns a list of links for each album' do
      expect(@albums_response.body).to include('<a href="/albums/1">Doolittle</a>')
      expect(@albums_response.body).to include('<a href="/albums/2">Surfer Rosa</a>')
    end

    #it 'returns a list of albums with their title and release year' do
    #  expect(@albums_response.body).to include('<div>
    #  Title: Doolittle
    #  Released: 1989
    #</div>')
      
    #  expect(@albums_response.body).to include('<div>
    #  Title: Surfer Rosa
    #  Released: 1988
    #</div>')
    #end
  end

  context "GET /albums/new" do
    before do
      @response = get('/albums/new')
    end
    
    it 'is a valid web path' do
      expect(@response.status).to eq (200)
    end

    it 'returns form for adding a new album' do
      expect(@response.body).to include ('<h1>Add an album</h1>')
      expect(@response.body).to include ('<form action="/albums" method="POST">') 
    end
  end


  context "GET /albums/:id" do
    
    before do
      @response1 = get('/albums/1')
      @response2 = get('/albums/2')
    end
    
    it 'is a valid web query' do
      expect(@response1.status).to eq(200)
      expect(@response2.status).to eq(200)
    end

    it 'returns album title as a heading' do
      expect(@response1.body).to include('<h1>Doolittle</h1>')
      expect(@response2.body).to include('<h1>Surfer Rosa</h1>')
    end

    it 'returns release year and artist in paragraph' do
      expect(@response1.body).to include('<p>
      Release year: 1989
      Artist: Pixies
    </p>')
      expect(@response2.body).to include('<p>
      Release year: 1988
      Artist: Pixies
    </p>')
    end
  end
  
  context "GET /artists" do
    before do
      @response = get('/artists')
    end
    
    it 'gives a 200 status code' do
      expect(@response.status).to eq (200)
    end
    
    it 'returns a list of links for each artist' do
      expect(@response.body).to include ('<a href="/artists/1">Pixies</a>')
      expect(@response.body).to include ('<a href="/artists/2">ABBA</a>')
    end


    #it 'returns the list of artists' do
    #  artist_list_response = get('/artists')
    #  expect(artist_list_response.body).to eq ('Pixies, ABBA, Taylor Swift, Nina Simone')
    #end
  end

  context "GET /artists/new" do
    before do
      @response = get('/artists/new')
    end
    
    it 'is a valid web path' do
      expect(@response.status).to eq (200)
    end

    it 'returns form for adding a new artist' do
      expect(@response.body).to include ('<h1>Add an artist</h1>')
      expect(@response.body).to include ('<form action="/artists" method="POST">') 
    end
  end

  context "GET /artists/:id" do
    before do
      @response1 = get('/artists/1')
      @response2 = get('/artists/2')
    end

    it 'is a valid web query' do
      expect(@response1.status).to eq (200)
      expect(@response2.status).to eq (200)
    end

    it 'has the artist name as the heading' do
      expect(@response1.body).to include('<h1>Pixies</h1>')
      expect(@response2.body).to include('<h1>ABBA</h1>')
    end

    it 'has the genre of the artist' do
      expect(@response1.body).to include('<p>Genre: Rock</p>')
      expect(@response2.body).to include('<p>Genre: Pop</p>')
    end
  end


  context "POST /albums" do
    it 'inserts the "Voyage" album into the albums table' do
      create_response = post('/albums', title: 'Voyage', release_year: '2022', artist_id: '2')

      expect(create_response.status).to eq(200)

      show_response = get('/albums')
      expect(show_response.status).to eq(200)
      expect(show_response.body).to include('<a href="/albums/13">Voyage</a>')
    end
  end

  context "POST /albums" do
    before do
      @response = post('/albums', title: 'Red', release_year: '2012', artist_id: '3')
    end

    it 'is a valid web request' do
      expect(@response.status).to eq (200)
    end

    it 'returns a success page' do
      expect(@response.body).to include ('<h1>Album added!</h1>')
    end

    it 'adds the album to the list' do
      album_response = get('/albums')
      expect(album_response.body).to include ('<a href="/albums/13">Red</a>')
    end

    it 'responds with 400 status if invalid parameters are given' do
      invalid_response1 = post('/albums')
      invalid_response2 = post('/albums', name: 'Red', year: '2012', id: '3')

      expect(invalid_response1.status).to eq (400)
      expect(invalid_response2.status).to eq (400)
    end
  end

  

  context "POST /artists" do
    before do
      @response = post('/artists', name: 'Wild nothing', genre: 'Indie')
    end

    it 'gives a 200 status code' do
      expect(@response.status).to eq (200)
    end

    it 'returns a success page' do
      expect(@response.body).to include ('<h1>Artist added!</h1>')
    end

    it 'adds the artist to the list' do
      get_response = get('/artists')
      expect(get_response.body).to include ('<a href="/artists/5">Wild nothing</a>')
    end

    it 'responds with 400 status if invalid parameters are given' do
      invalid_response1 = post('/artists')
      invalid_response2 = post('/artists', title: 'Wild nothing', category: 'Indie')

      expect(invalid_response1.status).to eq (400)
      expect(invalid_response2.status).to eq (400)
    end
  end

end