require 'excon'

module Apify
  	class Client
		URL = 'https://api.apify.com/'
		VERSION = "v2"
		
		def initialize(opts = {})
			@token = opts[:token] || ENV["APIFY_TOKEN"]
			@actorid = opts[:actorid]
		end

		def get_actor(params: {}, actorid: @actorid)
			conn.get(:path => "#{VERSION}/acts/#{actorid}", :query => params)
		end

		def get_actor_webhooks(params: {}, actorid: @actorid)
			conn.get(:path => "#{VERSION}/acts/#{actorid}/webhooks", :query => params)
		end

		def get_actor_run(params: {}, runid:)
			conn.get(:path => "#{VERSION}/actor-runs/#{runid}", :query => params)
		end

		def get_dataset(params: {}, datasetid:)
			conn.get(:path => "#{VERSION}/datasets/#{datasetid}", :query => params)
		end

		def get_dataset_items(params: {}, datasetid:)
			conn.get(:path => "#{VERSION}/datasets/#{datasetid}/items", :query => params)
		end

		def run_actor_async(params: {}, body: {}, actorid: @actorid)
			conn.post(:path => "#{VERSION}/acts/#{actorid}/runs", 
					  :query => params, 
					  :body => body.to_json,
					  :headers => { "Content-Type" => "application/json" })
		end

		private
			
		def conn
			@connection ||= Excon.new(URL, :headers => {'Authorization' => "Bearer #{@token}"})
		end

	end
end
