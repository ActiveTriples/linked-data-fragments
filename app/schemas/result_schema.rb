class ResultSchema < ActiveTriples::Schema
  property :subset, :predicate => RDF::VOID.subset

  # Descriptive
  property :title, :predicate => RDF::DC.title
  property :description, :predicate => RDF::DC.description
  property :source, :predicate => RDF::DC.source

  # Pagination
  property :triples_count, :predicate => RDF::VOID.triples
  property :total_items, :predicate => RDF::URI("http://www.w3.org/ns/hydra/core#totalItems")
  property :items_per_page, :predicate => RDF::URI("http://www.w3.org/ns/hydra/core#itemsPerPage")
  property :first_page, :predicate => RDF::URI("http://www.w3.org/ns/hydra/core#firstPage")
end
