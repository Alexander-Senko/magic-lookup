# frozen_string_literal: true

require 'active_support/core_ext/enumerable'
require 'active_support/core_ext/object/blank'

module Magic
	module Lookup
		# = Magic Lookup Scope
		#
		# Provides a scope for reverse lookup.
		#
		# 1. Define a base module including `Magic::Lookup::Scope`.
		# 2. Include the base module in the classes to be looked up.
		#
		# Example:
		#
		#     module Scopable
		#       include Magic::Lookup::Scope
		#     end
		#
		#     class Model
		#       include Scopable
		#     end
		#
		#     class MyModel < Model
		#     end
		#
		#     Scopable.for MyScope    # => MyModel
		#     Scopable.for OtherScope # => nil
		module Scope
			def self.included base
				return if base.is_a? Class # modules only

				base.extend ModuleFunctions
			end

			module ModuleFunctions # :nodoc:
				include Memery

				memoize def for lookup_class
					classes
							.select { lookup_class.match? it } # rubocop:disable Style/SelectByRegexp
							.tap do |classes|
								next unless classes.many? # nothing to filter

								break classes
										.select { lookup_class.name_match? it }
										.presence || next # lookup failed — leave original
							end
							.then do |classes|
								classes.min # the most specific one
							rescue ArgumentError # not inherited
								classes.sole
							end
				rescue Enumerable::SoleItemExpectedError => error
					raise Lookup::Error, "#{error.message
							.sub('items', [ *name, 'classes' ] * ' ')
					} for #{lookup_class}"
				end

				def classes
					ObjectSpace.each_object(Class)
							.select(&:name)
							.select { it < self }
							.reject(&:singleton_class?)
				end
			end
		end
	end
end
