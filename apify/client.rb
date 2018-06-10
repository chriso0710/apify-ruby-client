require 'faraday'
require 'json'

module Apify
  class Client
    attr_accessor :uid, :token

    def initialize(opts = {})
      @uid = opts[:uid]
      @token = opts[:token]
    end

    def get_list_of_crawlers(offset: 0, limit: 1000, desc: 1)
      call do
        conn.get(
          "#{uid}/crawlers?token=#{token}&offset=#{offset}&limit=#{limit}&desc=#{desc}"
        )
      end
    end

    def create_crawler(body: {})
      call do
        conn.post do |req|
          req.url "#{uid}/crawlers?token=#{token}"
          req.headers['Content-Type'] = 'application/json'
          req.body = JSON.dump(body)
        end
      end
    end

    # body = {
    #   "startUrls": [
    #     {
    #       "key": "START",
    #       "value": "https://www.marinetraffic.com/en/ais/details/ships/imo:7326350"
    #     }
    #   ]
    # }
    def update_crawler_setting(crawler_id:, body: {})
      call do
        conn.put do |req|
          req.url "#{uid}/crawlers/#{crawler_id}?token=#{token}"
          req.headers['Content-Type'] = 'application/json'
          req.body = JSON.dump(body)
        end
      end
    end

    def start_execution(crawler_id:, body: {})
      call do
        conn.post do |req|
          req.url "#{uid}/crawlers/#{crawler_id}/execute?token=#{token}"
          req.headers['Content-Type'] = 'application/json'
          req.body = JSON.dump(body)
        end
      end
    end

    def get_last_execution(crawler_id:)
      call do
        conn.get do |req|
          req.url "#{uid}/crawlers/#{crawler_id}/lastExec?token=#{token}"
          req.headers['Content-Type'] = 'application/json'
        end
      end
    end

    def last_execution_success?(crawler_id:)
      response = get_last_execution(crawler_id: crawler_id)
      response['status'] == "SUCCEEDED"
    end

    def get_last_execution_result(execution_id:)
      call do
        conn.get do |req|
          req.url "execs/#{execution_id}/results?format=json&simplified=1"
          req.headers['Content-Type'] = 'application/json'
        end
      end
    end

    private

    def conn
      @_conn ||= Faraday.new(url: 'https://api.apify.com/v1/') do |faraday|
        faraday.request  :url_encoded
        faraday.response :logger
        faraday.adapter  Faraday.default_adapter
      end
    end

    def call
      response = yield
      JSON.parse response.body
    end
  end
end
