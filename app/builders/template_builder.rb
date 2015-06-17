class TemplateBuilder
  attr_reader :dataset_node, :template
  def initialize(dataset_node, template)
    @dataset_node = dataset_node
    @template = template
  end

  def build
    Template.new(nil, dataset_node).tap do |template|
      template.template = self.template
    end
  end

  private

  def template_factory
    Template
  end
end
