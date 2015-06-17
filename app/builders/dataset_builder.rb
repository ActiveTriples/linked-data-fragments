class DatasetBuilder
  attr_writer :uri_endpoint
  def uri_endpoint
    @uri_endpoint ||= Setting.uri_endpoint
  end

  def root_uri
    @root_uri ||= Setting.root_uri
  end

  def build
    Dataset.new(root_uri).tap do |dataset|
      dataset.uri_lookup_endpoint = uri_endpoint
      dataset.search = template_builder.new(dataset, uri_endpoint).build
    end
  end

  private

  def template_builder
    TemplateBuilder
  end
end
