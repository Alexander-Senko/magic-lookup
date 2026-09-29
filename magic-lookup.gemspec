# frozen_string_literal: true

require_relative 'lib/magic/lookup/version'
require_relative 'lib/magic/lookup/authors'

Gem::Specification.new do |spec|
	spec.name        = 'magic-lookup'
	spec.version     = Magic::Lookup::VERSION
	spec.authors     = Magic::Lookup::Author.names
	spec.email       = Magic::Lookup::Author.emails
	spec.homepage    = "#{Magic::Lookup::Author.github_url}/#{spec.name}"
	spec.summary     = 'Related class inference with some magic involved'
	spec.description = 'Find a related class for an object (ex., a decorator, a presenter, a controller, or whatever).'
	spec.license     = 'MIT'

	spec.metadata['homepage_uri']    = spec.homepage
	spec.metadata['source_code_uri'] = spec.homepage
	spec.metadata['changelog_uri']   = "#{spec.metadata['source_code_uri']}/blob/v#{spec.version}/CHANGELOG.md"

	# Specify which files should be added to the gem when it is released.
	# The `git ls-files -z` loads the files in the RubyGem that have been added into git.
	spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
		ls.readlines("\x0", chomp: true).select do
			it in %r'^(lib|sig)/' | /\.(md|txt)$/ | 'Rakefile'
		end
	end

	spec.required_ruby_version = '>= 3.4'

	spec.add_dependency 'activesupport'
	spec.add_dependency 'memery'
end
