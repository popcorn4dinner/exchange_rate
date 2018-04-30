
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "exchange_rate/version"

Gem::Specification.new do |spec|
  spec.name          = "exchange_rate"
  spec.version       = ExchangeRate::VERSION
  spec.authors       = ["Bastian Schnieders"]
  spec.email         = ["bastian.schnieders@me.com"]

  spec.summary       = "handles exchange rates for you"
  spec.description   = "probably the world simplest way to exchange money"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  s.files       = Dir['lib/**/*.rb']

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'bigdecimal'
  spec.add_dependency 'nokogiri'

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
