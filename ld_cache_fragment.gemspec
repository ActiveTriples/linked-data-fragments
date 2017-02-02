
#!/usr/bin/env ruby -rubygems
# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.version       = '0.1.0'
  gem.name          = 'ld_cache_fragment'
  gem.summary       = "A Linked Data Caching Server"
  gem.authors       = ['Steven Anderson', 'Tom Johnson', 'Trey Pendragon']
  gem.platform      = Gem::Platform::RUBY
  gem.require_paths = %w(lib)
  gem.has_rdoc      = false

  gem.required_ruby_version = '>= 2.2.2'

  gem.add_runtime_dependency 'active-triples'
  gem.add_runtime_dependency 'rdf',           '~> 1.99'
  gem.add_runtime_dependency 'rdf-turtle',    '~> 1.99'
  gem.add_runtime_dependency 'json-ld',       '~> 1.99'
  gem.add_runtime_dependency 'rdf-vocab',     '0.8.7.1'
end
