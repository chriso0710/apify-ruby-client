require_relative 'lib/apify/version'

Gem::Specification.new do |spec|
  spec.name          = "apify_ruby_client"
  spec.version       = Apify::VERSION
  spec.authors       = ["Christian Ott"]
  spec.email         = ["co@hayvalley.io"]

  spec.summary       = %q{Ruby client for Apify https://www.apify.com/.}
  spec.description   = %q{Ruby client for Apify API V2 https://docs.apify.com/api/v2.}
  spec.homepage      = "https://github.com/chriso0710/apify-ruby-client"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/chriso0710/apify-ruby-client"
  spec.metadata["changelog_uri"] = "https://github.com/chriso0710/apify-ruby-client/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "faraday", '~> 2.7'

  spec.add_development_dependency "rake", '~> 12.0'
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "minitest-reporters", "~> 1.1"
  spec.add_development_dependency "vcr", '~> 6.0'
  spec.add_development_dependency "sinatra", "~> 3.0"
  spec.add_development_dependency "puma", "~> 6.0"
  spec.add_development_dependency "rack-test", "~> 2.0"
end
