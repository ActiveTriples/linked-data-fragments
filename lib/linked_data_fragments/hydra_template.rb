module LinkedDataFragments
  class HydraTemplate
    CONTROL_REGEX  = /{\??(.*?)}/.freeze
    PATH_REGEX     = /{([^\?]*?)}/.freeze
    QUERY_REGEX    = /{\?(.*?)}/.freeze
    TEMPLATE_REGEX = %r((http://[^{}]*\/)(#{CONTROL_REGEX}\/?)+).freeze

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
    # Gives a list of valid `void:uriLookupEndpoint`s derived from the template.
    #
    # @todo Don't hard code control mappings
    #
    # @return [Array<String>] a list of lookup endpoints based on the template
    # @see https://www.w3.org/TR/void/#lookup
    def lookup_endpoints
      if controls.include?('subject')
        case template
        when QUERY_REGEX
          [template.match(TEMPLATE_REGEX)[1] + '?subject=']
        when PATH_REGEX
          controls.first == 'subject' ? [template.match(TEMPLATE_REGEX)[1]] : []
        end
      else
        []
      end
    end

    ##
    # @return [String] the template
    def to_s
      @template.to_s
    end
  end
end
