class DatasetController < ApplicationController
  def index
    data = LinkedDataFragments::DatasetBuilder.new.build

    respond_to do |f|
      renderer_mapping.each do |format, renderer|
        f.send(format) do
          render :text => renderer.call(data)
        end
      end
    end
  end

  def show
    data = LinkedDataFragments::DatasetBuilder.for(name: params[:id])

    respond_to do |f|
      renderer_mapping.each do |format, renderer|
        f.send(format) do
          render :text => renderer.call(data)
        end
      end
    end
  end
end
