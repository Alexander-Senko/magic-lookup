# frozen_string_literal: true

module Magic
	module_function

	# Eager-loads subdirectories under the +app/+ directory for the given scopes
	# via the main Rails autoloader, unless global eager loading is already active.
	#
	# @param scopes [Array<#to_s>] scope names (e.g., +:scopes+, +:models+) corresponding to directories under +app/+.
	# @param engine [Rails::Engine, Rails::Application] the Rails engine or application containing the target directories.
	# @return [Array<Pathname>, nil] the eager-loaded directory paths, or +nil+ if application eager loading is enabled.
	def eager_load *scopes, engine: Rails.application
		return if Rails.application.config.eager_load

		scopes
				.map(&:to_s)
				.map(&:pluralize)
				.map { engine.root / 'app' / it }
				.select(&:exist?)
				.each { Rails.autoloaders.main.eager_load_dir it }
	end
end
