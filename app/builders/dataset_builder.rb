class DatasetBuilder
  attr_writer :uri_endpoint
  def uri_endpoint
    @uri_endpoint ||= HydraTemplate.new(Setting.uri_endpoint)
  end

  def uri_root
    @uri_root ||= Setting.uri_root
  end

  def build
    Dataset.new(uri_root).tap do |dataset|
      dataset.uri_lookup_endpoint = uri_endpoint.to_s
      dataset.search = template_builder.new(dataset, uri_endpoint).build
      uri_endpoint.controls.each do |control|
        dataset.search.first.mapping << control_builder.new(control, control_mapping[control]).build
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
    {
      "subject" => RDF.subject
    }
  end
end
