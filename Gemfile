# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in magic-lookup.gemspec
gemspec

gem 'rake'

group :test do
	gem 'rspec'
	gem 'rspec-its'
	gem 'magic-support'

	gem 'simplecov', require: false
end

group :development do
	gem 'rubocop',       require: false
	gem 'rubocop-rspec', require: false
	gem 'rubocop-rake',  require: false

	gem 'rbs'
end
