require 'rails/generators'

module LinkedDataFragments
  ##
  # linked_data_fragments:install generator
  class Install < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def inject_routes
      route "mount LinkedDataFragments::Engine, at: 'ldf'"
    end

    def copy_config
      copy_file 'config/ldf.yml', 'config/ldf.yml'
    end

    def inject_mime_types
      append_to_file 'config/initializers/mime_types.rb' do
        "Mime::Type.register \"application/ld+json\", :jsonld\n" \
        "Mime::Type.register \"application/n-triples\", :nt\n" \
        "Mime::Type.register \"text/turtle\", :ttl\n"
      end
    end
  end
end
