class ControlBuilder
  attr_accessor :control, :property
  def initialize(control, property)
    @control = control
    @property = property
  end

  def build
    control_factory.new.tap do |t|
      t.variable = control
      t.property = property
    end
  end

  private

  def control_factory
    Control
  end
end
