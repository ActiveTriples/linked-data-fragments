# -*- encoding : utf-8 -*-
require 'jettywrapper'

module LinkedDataFragments
  class Marmotta < Rails::Generators::Base

    desc """
Installs a jetty container with a solr and marmotta installed in it.
Requires system('unzip... ') to work, probably won't work on Windows.
"""

    def download_marmotta
      Jettywrapper.url = "https://github.com/dpla/marmotta-jetty/archive/develop.zip"
      Jettywrapper.unzip
    end


  end
end