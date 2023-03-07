require "spec_helper"
require "rack/test"
require_relative '../../app'

def reset_albums_table
  seed_sql = File.read('spec/seeds/albums_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  before(:each) do 
    reset_albums_table
  end

  context "POST /albums" do
    it 'inserts the "Voyage" album into the albums table' do
      create_response = post('/albums', title: 'Voyage', release_year: '2022', artist_id: '2')

      expect(create_response.status).to eq(200)

      show_response = get('/albums/14')
      expect(show_response.status).to eq(200)
      expect(show_response.body).to eq('Voyage')
    end
  end

end