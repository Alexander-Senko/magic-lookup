# frozen_string_literal: true

module Magic
	module Lookup
		module Namespaces # :nodoc:
			attr_writer :namespaces

			def namespaces = @namespaces ||= [ nil ]

			def for object_class, *namespaces
				return super unless namespaces.empty?

				self.namespaces
						.reverse # recently added first
						.lazy    # optimization
						.filter_map { super object_class, _1 }
						.first
			end
		end
	end
end
