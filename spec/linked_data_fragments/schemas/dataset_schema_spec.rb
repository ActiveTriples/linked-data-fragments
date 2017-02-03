require 'spec_helper'

describe LinkedDataFragments::DatasetSchema do
  it_behaves_like 'a schema', [:subset, :uri_lookup_endpoint, :search, :member]
end
