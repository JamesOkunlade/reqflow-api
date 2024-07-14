source "https://rubygems.org"

ruby "3.2.2"

gem 'appmap', :groups => [:development, :test]

gem "rails", "~> 7.1.3", ">= 7.1.3.4"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"

gem 'jwt', '~> 2.8', '>= 2.8.2'
gem 'aasm', '~> 5.5'
gem 'active_model_serializers', '~> 0.10.14'
gem 'money-rails', '~> 1.15'
gem 'pundit', '~> 2.3', '>= 2.3.2'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

gem "bcrypt", "~> 3.1.7"

gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
gem "rack-cors"


# gem 'sorbet', :group => :development
# gem 'sorbet-runtime'
# gem 'tapioca', require: false, :group => [:development, :test]


group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]
  gem 'rspec-rails', '~> 6.1', '>= 6.1.3'
  gem 'annotate', '~> 3.2'
end

group :test do
  gem 'factory_bot_rails', '~> 6.4', '>= 6.4.3'
  gem 'shoulda-matchers', '~> 6.2'
  gem 'faker', '~> 3.4', '>= 3.4.1'
  gem 'database_cleaner', '~> 2.0', '>= 2.0.2'
end
