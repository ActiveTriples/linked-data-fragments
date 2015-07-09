class DatasetController < ApplicationController
  def index
    @data = built_dataset

    if !renderer_mapping.keys.include?(request.format.symbol)
      raise ActionController::RoutingError.new("Invalid response format specified. Valid response formats are: #{renderer_mapping.keys.join(', ')} (#{renderer_mapping_to_strings.join(', ')}). Example url of how to set format: #{request.base_url}?format=jsonld")
    end

    respond_to do |f|
      renderer_mapping.each do |format, renderer|
        f.send(format) do
          render :text => renderer.call(@data)
        end
      end
    end
  end

  private

  def built_dataset
    DatasetBuilder.new.build
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
