# POST /sort-names Route Design Recipe

## 1. Design the Route Signature

  * the HTTP method - POST
  * the path - /sort-names
  * any query parameters (passed in the URL) - none
  * or body parameters (passed in the request body) - names (string)

## 2. Design the Response

With body parameters:
names=Joe,Alice,Zoe,Julia,Kieran
```
Alice,Joe,Julia,Kieran,Zoe
```

## 3. Write Examples

```
# Request:

POST /sort-names

  With body parameters:
  names=Joe,Alice,Zoe,Julia,Kieran

    # Expected response:
      Status - Response for 200 OK
      Body - Alice,Joe,Julia,Kieran,Zoe

  With body parameters:
  names=Ross,Chandler,Joey,Monica,Rachel,Phobea

    # Expected response:
      Status - Response for 200 OK
      Body - Chandler,Joey,Monica,Phobea,Rachel,Ross

  
```

## 4. Encode as Tests Examples

```ruby
# file: spec/integration/app_spec.rb

require "spec_helper"
require "rack/test"
require_relative "../../app"

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  context "POST /sort-names" do
    it 'returns "Alice,Joe,Julia,Kieran,Zoe"' do
      response = post('/sort-names', names: "Joe,Alice,Zoe,Julia,Kieran")

      expect(response.status).to eq(200)
      expect(response.body).to eq("Alice,Joe,Julia,Kieran,Zoe")
    end

    it 'returns "Chandler,Joey,Monica,Phobea,Rachel,Ross"' do
      response = post('/sort-names', names: "Ross,Chandler,Joey,Monica,Rachel,Phobea")

      expect(response.status).to eq(200)
      expect(response.body).to eq("Chandler,Joey,Monica,Phobea,Rachel,Ross")
    end
  end
end
```

## 5. Implement the Route

Write the route and web server code to implement the route behaviour.
