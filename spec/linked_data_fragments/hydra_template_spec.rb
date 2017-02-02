require 'spec_helper'

describe LinkedDataFragments::HydraTemplate do
  subject        { described_class.new(template) }
  let(:template) { 'http://localhost:4000/{?subject}' }
  
  describe '#controls' do
    it 'should return the mapped controls' do
      expect(subject.controls).to eq ['subject']
    end

    context 'when given multiple controls' do
      let(:template) { 'http://localhost:4000/{?subject,predicate, object}' }

      it 'should return all of them' do
        expect(subject.controls).to eq ['subject', 'predicate', 'object']
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
        expect(subject.controls).to eq ['subject', 'predicate']
      end
    end
  end

  describe '#to_s' do
    it 'should be the template' do
      expect(subject.to_s).to eql template
    end
  end
end
