class HydraTemplate
  attr_reader :template
  delegate :to_s, :to => :template

  def initialize(template)
    @template = template
  end

  # @return [Array<String>] Array of controls in template.
  def controls
    @controls ||= template.scan(control_regex)
      .flatten # Reduce multiple matches
      .flat_map{|x| x.split(",")} # Split on commas for matches
      .map(&:strip) # Strip whitespace
  end

  private

  def control_regex
    /{\??(.*?)}/
  end
end
