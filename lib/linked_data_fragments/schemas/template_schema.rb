module LinkedDataFragments
  ##
  # Schema for template models
  class TemplateSchema < ActiveTriples::Schema
    property :template, :predicate => RDF::Vocab::HYDRA.search
    property :mapping,  :predicate => RDF::Vocab::HYDRA.mapping
  end
end
