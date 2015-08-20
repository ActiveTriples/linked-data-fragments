class DatasetController < ApplicationController

  def index
    @data = built_dataset

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


end
