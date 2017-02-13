shared_examples 'a backend' do
  let(:url)     { 'http://dbpedia.org/resource/Berlin' }
  let(:context) { RDF::URI('http://example.com/dataset/lcsh') }

  after { subject.delete_all! }
  
  describe '.for' do
    it 'defaults to Repostiory' do
      expect(described_class.for)
        .to be_a LinkedDataFragments::Repository
    end

    it 'raises ArgumentError when name does not exist' do
      expect { described_class.for(name: :totally_fake) }
        .to raise_error LinkedDataFragments::BackendBase::UnsupportedBackend
    end
  end

  describe '#add', :vcr do
    it 'adds a url' do
      expect { subject.add(url) }
        .to change { subject.has_resource?(url) }.from(false).to(true)
    end

    context 'when given a context' do
      after { subject.delete_all!(context: context) }

      it 'adds a url to context' do
        expect { subject.add(url, context: context) }
          .to change { subject.has_resource?(url, context: context) }
          .from(false).to(true)
      end

      it 'does not add url to base dataset' do
        expect { subject.add(url, context: context) }
          .not_to change { subject.has_resource?(url) }
      end
    end
  end

  describe '#cache_backend_context' do
    let(:context) { 'http://example.com/my_named_graph' }

    it 'has a backend context' do
      unless subject.cache_backend_context.nil?
        expect(subject.cache_backend_context).to be_a String
      end
    end

    it 'sets backend context' do
      expect { subject.cache_backend_context = context }
        .to change { subject.cache_backend_context }.to eq context
    end
  end

  describe '#cache_backend_url' do
    it 'has a backend url' do
      unless subject.cache_backend_url.nil?
        expect(subject.cache_backend_url).to be_a String
      end
    end

    it 'sets backend url' do
      expect { subject.cache_backend_url = url }
        .to change { subject.cache_backend_url }.to eq url
    end
  end

  describe '#delete_all!', :vcr do
    it 'removes resources' do
      subject.add(url)

      expect { subject.delete_all! }
        .to change { subject.has_resource?(url) }.from(true).to(false)
    end

    it 'empties backend' do
      subject.add(url)
      
      expect { subject.delete_all! }
        .to change { subject.empty? }.from(false).to(true)
    end

    context 'with a context' do
      before { subject.add(url, context: context) }
      
      it 'removes the resource' do
        expect { subject.delete_all!(context: context) }
          .to change { subject.has_resource?(url, context: context) }
          .from(true).to(false)
      end

      it 'empties the context' do
        expect { subject.delete_all!(context: context) }
          .to change { subject.empty?(context: context) }
          .from(false).to(true)
      end

      it 'does not empty other graphs' do
        subject.add(url)

        expect { subject.delete_all!(context: context) }
          .not_to change { subject.has_resource?(url) }
      end
    end

  end

  describe '#empty?', :vcr do
    it 'becomes non-empty when a resource is added' do
      expect { subject.add(url) }
        .to change { subject.empty? }.from(true).to(false)
    end

    context 'with a context' do
      it 'becomes non-empty when a resource is added' do
        expect { subject.add(url, context: context) }
          .to change { subject.empty?(context: context) }
          .from(true).to(false)
      end

      it 'remains empty when a resource is added to a different graph' do
        expect { subject.add(url) }
          .not_to change { subject.empty?(context: context) }
      end
    end
  end

  describe '#has_resource?', :vcr do
    it 'has a resource that has been added' do
      subject.add(url)

      expect(subject).to have_resource url
    end

    context 'with a context' do
      it 'has a resource that has been added' do
        subject.add(url, context: context)

        expect(subject.has_resource?(url, context: context)).to be true
      end
    end
  end

  describe '#retrieve' do
    context 'when empty', :vcr do
      it 'loads a valid URL' do
        expect(subject.retrieve(url)).to respond_to :each_statement
      end

      it 'raises on invalid URL' do
        expect { subject.retrieve('http://example.com/moomin') }
          .to raise_error IOError
      end

      context 'with a context' do
        it 'loads a valid URL' do
          expect(subject.retrieve(url, context: context))
            .to respond_to :each_statement
        end

        it 'raises on invalid URL' do
          invalid = 'http://example.com/moomin'

          expect { subject.retrieve(invalid, context: context) }
            .to raise_error IOError
        end
      end
    end

    context 'with an existing resource', :vcr do
      before { subject.add(url) }

      it 'gets an RDF::Enumerable' do
        expect(subject.retrieve(url)).to respond_to :each_statement
      end

      it 'raises IOError on invalid URL' do
        expect { subject.retrieve('http://example.com/moomin') }
          .to raise_error IOError
      end

      context 'with a context' do
        it 'gets an RDF::Enumerable' do
          expect(subject.retrieve(url, context: context))
            .to respond_to :each_statement
        end

        it 'raises IOError on invalid URL' do
          expect { subject.retrieve('http://example.com/moomin', context: context) }
            .to raise_error IOError
        end
      end
    end
  end
end
