class Result
  include ActiveTriples::RDFSource
  configure :type => [
    RDF::URI("http://www.w3.org/ns/hydra/core#Collection"),
    RDF::URI("http://www.w3.org/ns/hydra/core#PagedCollection")
  ]
  apply_schema ResultSchema

end
