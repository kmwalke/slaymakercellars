source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

gem 'bcrypt'
gem 'bootsnap'
gem 'jbuilder'
gem 'pg'
gem 'puma'
gem 'rails', '6.1.3'
gem 'sass-rails'
gem 'turbolinks'
gem 'vinochipper'
gem 'webpacker'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'guard'
  gem 'guard-livereload'
  gem 'guard-rspec'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'sprockets', '3.7.2' # greater versions break on windows https://github.com/rails/sprockets/issues/283
end

group :development do
  gem 'listen'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rspec'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'rails-controller-testing'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end
