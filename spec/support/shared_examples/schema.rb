shared_examples 'a schema' do |properties|
  let(:fake_source) do
    klass = Class.new { include ActiveTriples::RDFSource }
    klass.apply_schema described_class
    klass
  end

  let(:source) { fake_source.new }
  let(:value)  { :moomin }

  properties.each do |property|
    it "has configured property #{property}" do
      expect { source.send("#{property}=".to_sym, value) }
        .to change { source.send(property).to_a }
              .to contain_exactly(value)
    end
  end
end
