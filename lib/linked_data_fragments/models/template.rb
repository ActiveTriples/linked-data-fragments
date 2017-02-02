module LinkedDataFragments
  class Template
    include ActiveTriples::RDFSource

    apply_schema LinkedDataFragments::TemplateSchema
  end
end
