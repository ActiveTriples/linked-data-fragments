source 'https://rubygems.org'

gemspec

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

gem 'responders'

gem 'rdf-turtle'
gem 'json-ld', '~> 1.99'
gem 'marmotta'
gem 'rdf-blazegraph'

group :development, :test do
  gem 'jettywrapper', '>= 2.0.0'
  gem 'ldfwrapper', github: 'boston-library/ldf-wrapper', branch: "master"
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'rspec-rails'
  gem 'pry-byebug'
end

group :development do
  gem 'guard-rspec'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
end

group :test do
  gem 'vcr'
  gem 'webmock'
end
