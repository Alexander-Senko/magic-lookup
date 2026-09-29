# frozen_string_literal: true

require 'active_support/concern'
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
						extend ActiveSupport::Concern

						include Scope

						included do
							extend ClassMethods # WTF?!

							@loading_scope = scope
						end

						class_methods do # public API
							def classes
								Magic.eager_load @loading_scope

								super
							end
						end
					end
				end
			end
		end
	end
end
