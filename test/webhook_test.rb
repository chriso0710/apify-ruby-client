require "test_helper"
require "server"
require "rack/test"

class WebhookTest < Minitest::Test

    include Rack::Test::Methods

    def app
        Sinatra::Application
    end

    def test_it_says_hello_world
        get '/'
        assert last_response.ok?
        assert_equal 'Hello World!', last_response.body
    end

    def test_successful_webhook
        data = File.read('test/successful_run.json')
        post '/apify', data, { "CONTENT_TYPE" => "application/json" }
        assert last_response.ok?
    end

    def test_failed_webhook
        data = File.read('test/failed_run.json')
        post '/apify', data, { "CONTENT_TYPE" => "application/json" }
        assert last_response.ok?
    end

    def test_invalid_webhook
        post '/apify', {}.to_json
        assert_equal 400, last_response.status
    end
	
end
