
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "lewdtillian/version"

Gem::Specification.new do |spec|
  spec.name          = "lewdtillian"
  spec.version       = Lewdtillian::VERSION
  spec.authors       = ["Castone22"]
  spec.email         = ["castone22@gmail.com"]

  spec.summary       = %q{A small discord bot for playing around with the discord bot api for ruby}
  spec.homepage      = "http://pages.github.com/castone22/lewdtillian"
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

  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_dependency 'discordrb'
  spec.add_dependency 'activesupport'
  spec.add_dependency 'google-api-client'
  spec.add_dependency 'sinatra'
end
