$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'engine_cart'
EngineCart.load_application!

require 'marmotta'
require 'rdf/blazegraph'
require 'linked_data_fragments'
require 'vcr_setup'
