shared_examples 'a backend' do
  let(:url) { 'http://dbpedia.org/resource/Berlin' }

  after { subject.delete_all! }

  describe '#add', :vcr do
    it 'adds a url' do
      expect { subject.add(url) }
        .to change { subject.has_resource?(url) }.from(false).to(true)
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
  end

  describe '#empty?', :vcr do
    it 'becomes non-empty when a resource is added' do
      expect { subject.add(url) }
        .to change { subject.empty? }.from(true).to(false)
    end
  end

  describe '#has?', :vcr do
    it 'has a resource that has been added' do
      subject.add(url)

      expect(subject).to have_resource url
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
    end
  end
end
