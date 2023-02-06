require "test_helper"

class ApifyTest < Minitest::Test
	ACTORID 	= "zuzka~instagram-hashtag-scraper"
	ACTORNAME   = "instagram-hashtag-scraper"
	RUNID 		= "sKSx9HD3VWVWZyvza"		
	DATASETID 	= "mUQjPuALPFYWxiv0q"
	HASHTAGS	= {hashtags: ["bikepacking","paris"], resultsLimit: 50}

	def test_that_it_has_a_version_number
		refute_nil ::Apify::VERSION
	end

	def test_get_actors_with_valid_token
		VCR.use_cassette("actors") do
			c = Apify::Client.new
			r = c.get_actor(actorid: ACTORID)
			assert_equal 200, r.status
			assert_equal ACTORNAME, r.body[:data][:name]
		end	
	end

	def test_get_actor_webhooks
		VCR.use_cassette("actor_webooks") do
			c = Apify::Client.new
			r = c.get_actor_webhooks(actorid: ACTORID)
			assert_equal 200, r.status
			assert_equal 1, r.body[:data][:total]
		end	
	end

	def test_run_actor
		VCR.use_cassette("run_actor_async") do
			c = Apify::Client.new
			r = c.run_actor_async(actorid: ACTORID, body: HASHTAGS)
			assert_equal 201, r.status
			assert_equal "READY", r.body[:data][:status]
		end
	end

	def test_get_actor_run
		VCR.use_cassette("actor_run") do
			c = Apify::Client.new
			r = c.get_actor_run(runid: RUNID)
			assert_equal 200, r.status
			assert_equal "SUCCEEDED", r.body[:data][:status]
			assert_equal DATASETID, r.body[:data][:defaultDatasetId]
		end
	end
	
	def test_get_dataset
		VCR.use_cassette("dataset") do
			c = Apify::Client.new
			r = c.get_dataset(datasetid: DATASETID)
			assert_equal 200, r.status
			assert_equal 100, r.body[:data][:itemCount]
		end
	end

	def test_get_empty_dataset
		VCR.use_cassette("empty_dataset") do
			c = Apify::Client.new
			r = c.get_dataset(datasetid: "WmrVuHiUKXxDrr7s9")
			assert_equal 200, r.status
			assert_equal 0, r.body[:data][:itemCount]
		end
	end

	def test_get_dataset_items
		VCR.use_cassette("dataset_items") do
			c = Apify::Client.new
			r = c.get_dataset_items(params: {omit: "taggedUsers, childPosts"}, datasetid: DATASETID)
			assert_equal 200, r.status
			assert_equal 100, r.body.size
			post = r.body[0]
			assert_equal "CoCfAv2I5Rp", post[:shortCode]
			assert_match "fbcdn.net", post[:displayUrl]
			assert_equal "grizzlynotations", post[:ownerUsername]
			assert_match "#bikepacking", post[:caption]
		end
	end
	
end
