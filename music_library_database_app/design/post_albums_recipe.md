# POST /albums Route Design Recipe

## 1. Design the Route Signature

You'll need to include:
  * the HTTP method - POST
  * the path - /albums
  * any query parameters (passed in the URL) - none
  * or body parameters (passed in the request body) - title (string), release_year (string), artist_id (string)

## 2. Design the Response

Expected response (200 OK)
```html
(No content)
```
```

## 3. Write Examples

_Replace these with your own design._

```
# Request:

POST /albums
With body parameters: title=Voyage, release_year=2022, artist_id=2

# Expected response:

Response for 200 OK

# Request:

POST /albums
With body parameters: title=Friday Night Lights, release_year=2010, artist_id=6

# Expected response:

Response for 200 OK

## 4. Encode as Tests Examples

```ruby
# EXAMPLE
# file: spec/integration/application_spec.rb

require "spec_helper"

describe Application do
  include Rack::Test::Methods

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
end
```

## 5. Implement the Route

Write the route and web server code to implement the route behaviour.
