module LinkedDataFragments
  class HydraTemplate
    CONTROL_REGEX = /{\??(.*?)}/.freeze

    ##
    # @!attribute [r] template
    # @return [String]
    attr_reader :template

    ##
    # @param template [#to_s]
    def initialize(template)
      @template = template.to_s
    end

    ##
    # @return [Array<String>] Array of controls in template.
    def controls
      @controls ||= template.scan(CONTROL_REGEX)
        .flatten # Reduce multiple matches
        .flat_map{|x| x.split(",")} # Split on commas for matches
        .map(&:strip) # Strip whitespace
    end

    ##
    # @return [String] the template
    def to_s
      @template.to_s
    end
  end
end
