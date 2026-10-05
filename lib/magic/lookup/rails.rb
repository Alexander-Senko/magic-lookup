# frozen_string_literal: true

require 'magic/rails'
require 'memery'

require_relative 'scope'

module Magic
	module Lookup
		# Adds Rails eager loading for the reverse lookup.
		#
		# Assuming your source classes live under `app/my_scope`, you should
		# `include Magic::Lookup::Scope['my_scope']` instead of a plain
		# `include Magic::Lookup::Scope`.
		module Scope
			class << self
				include Memery

				memoize def [] scope
					Module.new do
						@scope = scope

						def self.included base
							return if base.is_a? Class # modules only

							base.include Scope
							base.extend  Rails::ModuleFunctions

							base.instance_variable_set :@loading_scope, @scope
						end
					end
				end
			end

			module Rails
				module ModuleFunctions # :nodoc:
					def classes
						Magic.eager_load @loading_scope

						super
					end
				end
			end
		end
	end
end
