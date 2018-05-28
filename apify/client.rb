require 'faraday'
require 'json'

module Apify
  class Client
    attr_accessor :uid, :token

    def initialize(opts = {})
      raise ArgumentError, 'Provide block to configure' unless block_given?
      yield(self)
    end

    def get_list_of_crawlers(offset: 0, limit: 1000, desc: 1)
      call do
        conn.get(
          "#{uid}/crawlers?token=#{token}&offset=#{offset}&limit=#{limit}&desc=#{desc}"
        )
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
