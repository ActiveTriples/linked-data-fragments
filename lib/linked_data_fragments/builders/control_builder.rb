module LinkedDataFragments
  class ControlBuilder
    ##
    # @!attribute [rw] control
    #   @return []
    # @!attribute [rw] property
    #   @return [RDF::URI]
    attr_accessor :control, :property

    ##
    #
    def initialize(control, property)
      @control = control
      @property = property
    end

    ##
    # @return [Control]
    def build
      Control.new.tap do |t|
        t.variable = control
        t.property = property
      end
    end
  end
end
