
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "apify/version"

Gem::Specification.new do |spec|
  spec.name          = "apify-ruby-client"
  spec.version       = Apify::VERSION
  spec.authors       = ["Christian Ott"]
  spec.email         = ["co@hayvalley.io"]

  spec.summary       = %q{Ruby client for Apify https://www.apify.com/.}
  spec.description   = %q{Ruby client for Apify API V2 https://docs.apify.com/api/v2.}
  spec.homepage      = ""
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "faraday", '~> 2.7'

  spec.add_development_dependency "bundler", '~> 2.1'
  spec.add_development_dependency "rake", '~> 13.0'
  spec.add_development_dependency "rspec", '~> 3.12'
end
