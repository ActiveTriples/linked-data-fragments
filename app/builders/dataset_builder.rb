class DatasetBuilder
  attr_writer :uri_endpoint
  def uri_endpoint
    @uri_endpoint ||= Setting.uri_endpoint
  end

  def root_uri
    @root_uri ||= Setting.root_uri
  end

  def build
    Dataset.new(root_uri).tap do |d|
      d.uri_lookup_endpoint = RDF::URI(uri_endpoint)
    end
  end
end
