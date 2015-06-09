##
# A class to hold site-wide configuration.
# @todo extract to a configuration file.
class Setting
  class << self
    def uri_endpoint
      "http://localhost:3000/{?subject}"
    end

    def root_uri
      "http://localhost:3000/#dataset"
    end
  end
end
