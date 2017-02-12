require 'spec_helper'

describe LinkedDataFragments::HydraTemplate do
  subject        { described_class.new(template) }
  let(:template) { 'http://localhost:4000/{?subject}' }
  
  describe '#controls' do
    it 'should return the mapped controls' do
      expect(subject.controls).to contain_exactly('subject')
    end

    context 'when given multiple controls' do
      let(:template) { 'http://localhost:4000/{?subject,predicate, object}' }

      it 'should return all of them' do
        expect(subject.controls)
          .to contain_exactly('subject', 'predicate', 'object')
      end
    end

    context 'with no controls' do
      let(:template) { 'http://localhost:4000' }
      
      it 'should return an empty array' do
        expect(subject.controls).to be_empty
      end
    end

    context 'with slashes to separate controls' do
      let(:template) { 'http://localhost:4000/{subject}/{predicate}' }

      it 'should return them' do
        expect(subject.controls).to contain_exactly('subject', 'predicate')
      end
    end
  end

  describe '#lookup_endpoints' do
    context 'with subject as an available control' do
      it 'gives the template uri' do
        expect(subject.lookup_endpoints)
          .to contain_exactly 'http://localhost:4000/?subject='
      end

      it 'varies to the URI geven' do
        template = 'http://example.com/{?subject}'
        subject  = described_class.new(template)

        expect(subject.lookup_endpoints)
          .to contain_exactly 'http://example.com/?subject='
      end
    end

    context 'with slashes to separate controls' do
      let(:template) { 'http://localhost:4000/blah/{subject}/{predicate}' }

      it 'gives the template uri' do
        expect(subject.lookup_endpoints)
          .to contain_exactly 'http://localhost:4000/blah/'
      end
    end

    context 'with non-appendable subject control' do
      let(:template) { 'http://localhost:4000/blah/{predicate}/{subject}' }
      
      it 'is empty' do
        expect(subject.lookup_endpoints).to be_empty
      end
    end

    context 'with no subject controls' do
      let(:template) { 'http://localhost:4000/{?predicate,object}' }
      
      it 'is empty' do
        expect(subject.lookup_endpoints).to be_empty
      end
    end
  end
  
  describe '#to_s' do
    it 'should be the template' do
      expect(subject.to_s).to eql template
    end
  end
end
