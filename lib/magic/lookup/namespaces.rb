# frozen_string_literal: true

module Magic
	module Lookup
		# = Configurable namespaces for Magic::Lookup
		#
		# Extends Magic::Lookup class methods to respect preconfigured
		# namespaces. Multiple default lookup namespaces may be set for the
		# base class.
		#
		# Example:
		#
		#     Scope.namespaces << MyNamespace # => [nil, MyNamespace]
		#     Scope.for MyModel               # => MyNamespace::MyScope
		module Namespaces
			attr_writer :namespaces

			def namespaces = @namespaces ||
					if superclass.respond_to? :namespaces
						superclass.namespaces
					else
						@namespaces = [ nil ]
					end

			def for object_class, *namespaces
				return super unless namespaces.empty?

				self.namespaces
						.reverse # recently added first
						.lazy    # optimization
						.filter_map { super object_class, it }
						.first
			end
		end
	end
end
