class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :verify_format

  def verify_format
    if !renderer_mapping.keys.include?(request.format.symbol)
      raise ActionController::RoutingError.new("Invalid response format specified. Valid response formats are: #{renderer_mapping.keys.join(', ')} (#{renderer_mapping_to_strings.join(', ')}). Example url of how to set format: #{request.base_url}?format=jsonld")
    end
  end


  def renderer_mapping
    {
        :nt => lambda { |data| data.dump(:ntriples) },
        :jsonld => lambda { |data| data.dump(:jsonld, :standard_prefixes => true) },
        :ttl => lambda { |data| data.dump(:ttl) }
    }
  end

  def renderer_mapping_to_strings
    result = []
    renderer_mapping.each do |format, renderer|
      result.append(Mime::Type.lookup_by_extension(format).to_s)
    end
    return result
  end
end
