def register_cache_endpoints
  LinkedDataFragments.configure do |config|
    # Example using LOC names sub-authority
    # register_cache_endpoint("http://id.loc.gov/authorities/names/", "loc_names", "application/ld+json", "3600", "linked data")
  end
end
register_cache_endpoints

Rails.application.config.to_prepare do
  register_cache_endpoints
end
