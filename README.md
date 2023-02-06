# Apify Ruby Client

This gem implements the following Apify V2 API calls:

* GET acts/#{actorid}
* GET acts/#{actorid}/webhooks
* POST actor-runs/#{runid}
* GET datasets/#{datasetid}
* GET datasets/#{datasetid}/items
* GET acts/#{actorid}/runs

It uses the Faraday gem (https://github.com/lostisland/faraday) for making API requests.
Actors can be run asynchronously, webhooks can be received and datasets can be retrieved.
That was enough for my current needs.

See the full API documentation at https://docs.apify.com/api/v2

## Installation

Add this line to your applications Gemfile:

```ruby
gem 'apify-ruby-client'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install apify-ruby-client

## Usage

The gem gets your API token from your environment variables as

    ENV["APIFY_TOKEN"]

You can also set the token when initializing the client:

```ruby
c = Apify::Client.new({token: "sometoken"})
```

Example for running an actor asynchronously:

```ruby
c = Apify::Client.new
c.run_actor_async(actorid: "someactor", body: {foo: "bar"})
```

See the tests for more usage examples in ```test/apify_test.rb```.

## Development

Run ```rake test``` to run the tests. 

All tests use VCR (https://github.com/vcr/vcr) with prerecorded responses from APIFY.
Webhooks are mocked with prerecorded json payloads, which are sent to a minimal sinatra webserver (```test/server.rb```). 

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/chriso0710/apify-ruby-client.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
