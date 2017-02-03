require 'rails_helper'

RSpec.describe Control do
  subject { described_class.new }
  
  it "should apply the control schema" do
    LinkedDataFragments::ControlSchema.properties.each do |property|
      expect(subject.class.properties[property.name.to_s].predicate).to eq property.predicate
    end
  end
end
