require "spec_helper"
require "rack/test"
require_relative "../../app"

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  context "GET /names" do
    it 'should return "Julia, Mary, Karim"' do
      names_response = get('/names')

      expect(names_response.status).to eq(200)
      expect(names_response.body).to eq('Julia, Mary, Karim')
    end
  end

  context "GET /hello" do
    it 'is a successful HTTP request' do
      response = get('/hello')
      expect(response.status).to eq(200)
    end

    #it 'says hello to the name given' do
    #  response = get('/hello?name=Samuel')
    #  expect(response.body).to eq('Hello Samuel')
    #end

    it 'returns the greeting message as an HTML page' do
      response = get('/hello?name=Samuel')
      expect(response.body).to include('<h1>Hello!</h1>')
    end

  end

  context "POST /sort-names" do
    it 'returns "Alice,Joe,Julia,Kieran,Zoe"' do
      sort_response1 = post('/sort-names', names: "Joe,Alice,Zoe,Julia,Kieran")

      expect(sort_response1.status).to eq(200)
      expect(sort_response1.body).to eq("Alice,Joe,Julia,Kieran,Zoe")
    end

    it 'returns "Chandler,Joey,Monica,Phobea,Rachel,Ross"' do
      sort_response2 = post('/sort-names', names: "Ross,Chandler,Joey,Monica,Rachel,Phobea")

      expect(sort_response2.status).to eq(200)
      expect(sort_response2.body).to eq("Chandler,Joey,Monica,Phobea,Rachel,Ross")
    end
  end
end