module LinkedDataFragments
  ##
  # Inherit from the host app's ApplicationController
  class ApplicationController < ::ApplicationController
    before_action :verify_format

    def verify_format
      if !renderer_mapping.keys.include?(request.format.symbol)
        raise ActionController::RoutingError.new("Invalid response format specified. Valid response formats are: #{renderer_mapping.keys.join(', ')} (#{renderer_mapping_to_strings.join(', ')}). Example url of how to set format: #{request.base_url}?format=jsonld")
      end
    end


    def self.renderer_mapping
      {
          :nt => lambda { |data| data.dump(:ntriples) },
          :jsonld => lambda { |data| data.dump(:jsonld, :standard_prefixes => true) },
          :ttl => lambda { |data| data.dump(:ttl) }
      }
    end

    def renderer_mapping
      self.class.renderer_mapping
    end

    def renderer_mapping_to_strings
      renderer_mapping.map do |format, renderer|
        Mime::Type.lookup_by_extension(format).to_s
      end
    end
  end
end
