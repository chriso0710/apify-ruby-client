require "test_helper"

class ApifyTest < Minitest::Test
	ACTORID 	= "zuzka~instagram-hashtag-scraper"
	ACTORNAME   = "instagram-hashtag-scraper"
	RUNID 		= "sKSx9HD3VWVWZyvza"		
	DATASETID 	= "mUQjPuALPFYWxiv0q"
	HASHTAGS	= {hashtags: ["bikepacking","paris"], resultsLimit: 50}

	def valid_json?(json)
  		begin
    		JSON.parse(json)
    		return true
  		rescue Exception
    		return false
  		end
	end

	def test_that_it_has_a_version_number
		refute_nil ::Apify::VERSION
	end

	def test_get_actors_with_valid_token
		VCR.use_cassette("actors") do
			c = Apify::Client.new
			r = c.get_actor(actorid: ACTORID)
			assert_equal 200, r.status
			assert valid_json? r.body
			j = JSON.parse r.body
			assert_equal ACTORNAME, j["data"]["name"]
		end	
	end

	def test_get_actor_webhooks
		VCR.use_cassette("actor_webooks") do
			c = Apify::Client.new
			r = c.get_actor_webhooks(actorid: ACTORID)
			assert_equal 200, r.status
			assert valid_json? r.body
			j = JSON.parse r.body
			assert_equal 1, j["data"]["total"]
		end	
	end

	def test_run_actor
		VCR.use_cassette("run_actor_async") do
			c = Apify::Client.new
			r = c.run_actor_async(actorid: ACTORID, body: HASHTAGS)
			assert_equal 201, r.status
			assert valid_json? r.body
			j = JSON.parse r.body
			assert_equal "READY", j["data"]["status"]
		end
	end

	def test_get_actor_run
		VCR.use_cassette("actor_run") do
			c = Apify::Client.new
			r = c.get_actor_run(runid: RUNID)
			assert_equal 200, r.status
			assert valid_json? r.body
			j = JSON.parse r.body
			assert_equal "SUCCEEDED", j["data"]["status"]
			assert_equal DATASETID, j["data"]["defaultDatasetId"]
		end
	end
	
	def test_get_dataset
		VCR.use_cassette("dataset") do
			c = Apify::Client.new
			r = c.get_dataset(datasetid: DATASETID)
			assert valid_json? r.body
			j = JSON.parse r.body
			assert_equal 200, r.status
			assert_equal 100, j["data"]["itemCount"]
		end
	end

	def test_get_empty_dataset
		VCR.use_cassette("empty_dataset") do
			c = Apify::Client.new
			r = c.get_dataset(datasetid: "WmrVuHiUKXxDrr7s9")
			assert valid_json? r.body
			j = JSON.parse r.body
			assert_equal 200, r.status
			assert_equal 0, j["data"]["itemCount"]
		end
	end

	def test_get_dataset_items
		VCR.use_cassette("dataset_items") do
			c = Apify::Client.new
			r = c.get_dataset_items(params: {omit: "taggedUsers, childPosts"}, datasetid: DATASETID)
			assert_equal 200, r.status
			assert valid_json? r.body
			j = JSON.parse r.body
			assert_equal 100, j.size
			post = j[0]
			assert_equal "CoCfAv2I5Rp", post["shortCode"]
			assert_match "fbcdn.net", post["displayUrl"]
			assert_equal "grizzlynotations", post["ownerUsername"]
			assert_match "#bikepacking", post["caption"]
		end
	end
	
end
