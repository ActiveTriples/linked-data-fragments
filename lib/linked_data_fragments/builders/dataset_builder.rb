module LinkedDataFragments
  ##
  # A Builder for Dataset instances.
  #
  # @example Building a dataset
  #   builder = DatasetBuilder.new
  #   builder.uri_endpoint = HydraTemplate.new('http://example.com/{?subject}')
  #   dataset = builder.build
  #
  #   dataset.dump :ttl
  #   # <http://localhost:3000/#dataset> a <http://www.w3.org/ns/hydra/core#Collection>,
  #   #    <http://rdfs.org/ns/void#Dataset>;
  #   # <http://rdfs.org/ns/void#uriLookupEndpoint> "http://example.com/{?subject}";
  #   # <http://www.w3.org/ns/hydra/core#search> [
  #   #    <http://www.w3.org/ns/hydra/core#mapping> [
  #   #       <http://www.w3.org/ns/hydra/core#property> <http://www.w3.org/1999/02/22-rdf-syntax-ns#subject>;
  #   #       <http://www.w3.org/ns/hydra/core#variable> "subject"
  #   #    ];
  #   #    <http://www.w3.org/ns/hydra/core#search> "http://example.com/{?subject}"
  #   # ] .
  class DatasetBuilder
    # @!attribute [w]
    #   @return [HydraTemplate]
    attr_writer :uri_endpoint

    def build
      Dataset.new(uri_root).tap do |dataset|
        dataset.uri_lookup_endpoint = uri_endpoint.to_s
        dataset.search = template_builder.new(dataset, uri_endpoint).build

        uri_endpoint.controls.each do |control|
          dataset.search.first.mapping << 
            control_builder.new(control, control_mapping[control]).build
        end
      end
    end

    ##
    # @return [HydraTemplate]
    # @see Settings#uri_endpoint
    def uri_endpoint
      @uri_endpoint ||= 
        LinkedDataFragments::HydraTemplate
          .new(Settings.uri_endpoint)
    end

    ##
    # @return [String] a URI-like string representing the root URI
    #
    # @see Settings#uri_root
    def uri_root
      Settings.uri_root
    end

    private

    def template_builder
      TemplateBuilder
    end

    def control_builder
      ControlBuilder
    end

    def control_mapping
      { "subject" => RDF.subject }
    end
  end
end
