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

  ##
  # @return [HydraTemplate]
  # @see Setting#uri_endpoint
  def uri_endpoint
    @uri_endpoint ||= 
      LinkedDataFragments::HydraTemplate.new(Setting.uri_endpoint)
  end

  ##
  # @return [String] a URI-like string representing the root URI
  #
  # @see Setting#uri_root
  def uri_root
    Setting.uri_root
  end

  ##
  # Builds a new `Dataset`.
  #
  # @return [Dataset] the built dataset
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
