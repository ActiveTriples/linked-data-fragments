class Template < ActiveTriples::Resource
  include ActiveTriples::RDFSource
  apply_schema TemplateSchema
end