module LinkedDataFragments
  ##
  # A Builder for Templates.
  class TemplateBuilder
    ##
    # @!attribute [r] dataset_node
    #   @return [Dataset]
    # @!attribute [r] uri_template
    #   @return [String]
    attr_reader :dataset_node, :uri_template

    ##
    # @param dataset_node [Dataset]
    # @param uri_template [#to_s]
    def initialize(dataset_node, uri_template)
      @dataset_node = dataset_node
      @uri_template = uri_template.to_s
    end

    def build
      Template.new(nil, dataset_node).tap do |template|
        template.template = self.uri_template
      end
    end
  end
end
