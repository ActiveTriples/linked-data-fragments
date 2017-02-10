module LinkedDataFragments
  ##
  # An RDFSource of type `hydracore:Collection`. Implements the metadata schema 
  # of `DatasetSchema`.
  class Dataset
    include ActiveTriples::RDFSource

    configure :type => [
                RDF::URI.intern("http://www.w3.org/ns/hydra/core#Collection"),
                RDF::Vocab::VOID.Dataset
              ]

    apply_schema LinkedDataFragments::DatasetSchema    
  end
end
