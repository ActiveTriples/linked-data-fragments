module LinkedDataFragments
  ##
  # Schema for Result model
  class ResultSchema < ActiveTriples::Schema
    property :subset,      :predicate => RDF::Vocab::VOID.subset

    # Descriptive
    property :title,       :predicate => RDF::Vocab::DC.title
    property :description, :predicate => RDF::Vocab::DC.description
    property :source,      :predicate => RDF::Vocab::DC.source

    # Pagination
    property :triples_count,  :predicate => RDF::Vocab::VOID.triples
    property :total_items,    :predicate => RDF::URI("http://www.w3.org/ns/hydra/core#totalItems")
    property :items_per_page, :predicate => RDF::URI("http://www.w3.org/ns/hydra/core#itemsPerPage")
    property :first_page,     :predicate => RDF::URI("http://www.w3.org/ns/hydra/core#firstPage")
  end
end

