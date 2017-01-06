require "linked_data_fragments/version"
require "linked_data_fragments/engine"
require 'active_triples'
require 'rdf/vocab'
require 'rdf/turtle'

module LinkedDataFragments
  extend ActiveSupport::Autoload

  autoload :BackendBase
  autoload :Blazegraph
  autoload :Marmotta
  autoload :Repository
end
