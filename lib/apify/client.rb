require 'faraday'

module Apify
  	class Client
		URL = 'https://api.apify.com/v2/'
		
		def initialize(opts = {})
			@token = opts[:token] || ENV["APIFY_TOKEN"]
			@actorid = opts[:actorid]
		end

		def get_actor(params: {}, actorid: @actorid)
			conn.get("acts/#{actorid}", params)
		end

		def get_actor_webhooks(params: {}, actorid: @actorid)
			conn.get("acts/#{actorid}/webhooks", params)
		end

		def get_actor_run(params: {}, runid:)
			conn.get("actor-runs/#{runid}", params)
		end

		def get_dataset(params: {}, datasetid:)
			conn.get("datasets/#{datasetid}", params)
		end

		def get_dataset_items(params: {}, datasetid:)
			conn.get("datasets/#{datasetid}/items", params)
		end

		def run_actor_async(params: {}, body: {}, actorid: @actorid)
			conn.post("acts/#{actorid}/runs") do |req|
				req.params = params
				req.body = body
			end
		end

		private
			
		def conn
			@connection ||= Faraday.new(url: URL) do |faraday|
				faraday.response :logger, nil, { headers: false, bodies: false, errors: true, log_level: :info }
				faraday.adapter Faraday.default_adapter
				faraday.request :json 
				faraday.response :json, parser_options: { symbolize_names: true }
				faraday.request :authorization, 'Bearer', @token
			end
		end

	end
end
