require 'active_triples'

# must require 'rdf/vocab' first, due to const_missing metaprogramming in 
# pre-2.0 verisons
require 'rdf/vocab'
require 'rdf/vocab/hydra'
require 'rdf/vocab/void'

require 'linked_data_fragments/schemas'
require 'linked_data_fragments/models'
require 'linked_data_fragments/hydra_template'

##
# A linked data caching fragment
module LinkedDataFragments
end
