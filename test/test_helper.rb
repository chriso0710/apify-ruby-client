$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "apify"

require "minitest/autorun"
require "minitest/reporters"

require "vcr"

Minitest::Reporters.use!

VCR.configure do |config|
    config.cassette_library_dir = "test/vcr_cassettes"
    config.hook_into :faraday
    config.filter_sensitive_data('<TOKEN>') { ENV['APIFY_TOKEN'] }
end