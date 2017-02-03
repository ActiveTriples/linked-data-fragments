require 'spec_helper'

describe LinkedDataFragments::ResultSchema do
  it_behaves_like 'a schema', [:subset, 
                               :title, 
                               :description, 
                               :source,
                               :triples_count,
                               :total_items,
                               :items_per_page,
                               :first_page
                              ]
end
