class Dataset
  include ActiveTriples::RDFSource
  configure :type => [
    RDF::URI("http://www.w3.org/ns/hydra/core#Collection"),
    RDF::Vocab::VOID.Dataset
  ]
  apply_schema DatasetSchema
end
