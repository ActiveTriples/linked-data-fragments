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
    # The fragment used for the dataset URI.
    FRAGMENT_ID = '#dataset'.freeze

    ##
    # @todo Add more precise handling for configured templates. The YAML config 
    #   could use an overhaul to make some of this more accessible.
    # @return [Dataset]
    def self.for(name:)
      uri = RDF::URI(Settings.uri_root)
      
      if uri.fragment
        uri.fragment = nil
        warn "Configured root URI: `#{Settings.uri_root}` has a fragment. This " \
             'will be overridden and replaced with `#dataset`. You should ' \
             "configure a root URI without a fragment; e.g. `#{uri}`."
      end

      uri      = uri / 'dataset' / name
      template = LinkedDataFragments::HydraTemplate.new("#{uri.to_s}/{?subject}")

      new(uri_root: uri, uri_endpoint: template).build
    end

    ##
    # @!attribute [r] control_mapping
    #   @return [Control]
    # @!attribute [r] uri_root
    #   @return [String] a URI-like string representing the root URI for the
    #     dataset.
    #   @see Settings#uri_root
    # @!attribute [rw] uri_endpoint
    #   @return [HydraTemplate]
    attr_reader :control_mapping, :uri_endpoint, :uri_root

    ##
    # @param control_mapping [Control]
    # @param uri_endpoint [HydraTemplate]
    # @param uri_root     [String] a URI-like string representing the root URI
    #   for the dataset.
    def initialize(control_mapping: { 'subject' => RDF.subject },
                   uri_endpoint:    default_template,
                   uri_root:        Settings.uri_root)
      @control_mapping = control_mapping
      @uri_endpoint    = uri_endpoint
      @uri_root        = RDF::URI.intern(uri_root) / FRAGMENT_ID
    end

    ##
    # @return [Dataset] the dataset built from the current builder state
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

    private

    def control_builder
      ControlBuilder
    end

    def template_builder
      TemplateBuilder
    end

    def default_template
      LinkedDataFragments::HydraTemplate.new(Settings.uri_endpoint)
    end
  end
end
