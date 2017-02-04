class SubjectController < ApplicationController
  before_action :fix_passed_params

  def self.cache_service
    LinkedDataFragments::Service.instance.cache
  end

  def subject
    data = self.class.cache_service.retrieve(params[:subject])

    respond_to do |f|
      renderer_mapping.each do |format, renderer|
        f.send(format) do
          render :text => renderer.call(data)
        end
      end
    end
  end

  private

  # Seems like a double '//' in the captured param is changed to a single one. 
  # Unsure of how better to do this...
  def fix_passed_params
    single_slash_match = params[:subject].match(/^http[s]*\:\/(?!\/)/)

    if single_slash_match.present?
      params[:subject] = 
        params[:subject][0..single_slash_match[0].length-1] + '/' +
        params[:subject][single_slash_match[0].length..params[:subject].length]
    end
  end
end
