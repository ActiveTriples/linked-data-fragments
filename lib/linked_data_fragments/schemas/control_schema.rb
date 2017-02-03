module LinkedDataFragments
  ##
  # A HydraCore control schema
  class ControlSchema < ActiveTriples::Schema
    property :variable, :predicate => RDF::Vocab::HYDRA.variable
    property :property, :predicate => RDF::Vocab::HYDRA.property, :cast => false
  end
end
