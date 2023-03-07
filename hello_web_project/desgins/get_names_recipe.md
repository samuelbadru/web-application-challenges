# Get /names Route Design Recipe


## 1. Design the Route Signature

You'll need to include:
  * the HTTP method - Get
  * the path - /names
  * any query parameters (passed in the URL) - none
  * or body parameters (passed in the request body) - none

## 2. Design the Response

```
Julia, Mary, Karim
```

## 3. Write Examples

```
# Request:

GET /names

# Expected response:
  Status - Response for 200 OK
  Body - Julia, Mary, Karim
```

```

## 4. Encode as Tests Examples

```ruby
# EXAMPLE
# file: spec/integration/app_spec.rb

require "spec_helper"

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  context "GET /names" do
    it 'should return "Julia, Mary, Karim"' do
      response = get('/names')

      expect(response.status).to eq(200)
      expect(response.body).to eq('Julia, Mary, Karim')
    end
  end
end
```

## 5. Implement the Route

Write the route and web server code to implement the route behaviour.
