class DatasetSchema < ActiveTriples::Schema
  property :subset, :predicate => RDF::VOID.subset
  property :uri_lookup_endpoint, :predicate => RDF::VOID.uriLookupEndpoint
  # Change search so that it points to a search node.
  property :search, :predicate => RDF::URI("http://www.w3.org/ns/hydra/core#search")
  property :member, :predicate => RDF::URI("http://www.w3.org/ns/hydra/core#member")
end
