class TemplateBuilder
  attr_reader :dataset_node, :uri_template
  def initialize(dataset_node, uri_template)
    @dataset_node = dataset_node
    @uri_template = uri_template.to_s
  end

  def build
    Template.new(nil, dataset_node).tap do |template|
      template.template = self.uri_template
    end
  end

  private

  def template_factory
    Template
  end
end
