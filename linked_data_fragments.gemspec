# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'linked_data_fragments/version'

Gem::Specification.new do |spec|
  spec.name          = "linked_data_fragments"
  spec.version       = LinkedDataFragments::VERSION
  spec.authors       = ["Justin Coyne"]
  spec.email         = ["jcoyne@justincoyne.com"]

  spec.summary       = %q{A partial implementation of Linked Data Fragments using a Rails engine.}
  #spec.description   = %q{}
  spec.homepage      = "https://github.com/ActiveTriples/linked-data-fragments"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "active-triples", "~> 0.7"
  spec.add_dependency "rdf-vocab", "~> 0.8"
  spec.add_dependency 'rdf-turtle', '~> 1.99'

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 11.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-rails", "~> 3.0"
  spec.add_development_dependency "engine_cart", "~> 0.8"
  spec.add_development_dependency 'marmotta'
  spec.add_development_dependency 'rdf-blazegraph'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'

end
