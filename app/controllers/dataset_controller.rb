class DatasetController < ApplicationController
  def index
    @data = built_dataset
    render_format(@data)
  end

  private

  def built_dataset
    DatasetBuilder.new.build
  end

  def render_format(data, format=:jsonld)
    respond_to do |f|
      f.send(format) do
        render :text => data.dump(format, :standard_prefixes => true)
      end
    end
  end
end
