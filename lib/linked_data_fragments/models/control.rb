module LinkedDataFragments
  class Control
    include ActiveTriples::RDFSource
    apply_schema LinkedDataFragments::ControlSchema
  end
end
