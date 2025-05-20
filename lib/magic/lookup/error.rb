# frozen_string_literal: true

module Magic
	module Lookup
		# = Magic Lookup Error
		#
		# When no class is found, `nil` is returned. If you need to raise
		# an exception in this case, you can use `Magic::Lookup::Error`
		# like this:
		#
		#     scope_class = Scope.for(object.class) or
		#         raise Magic::Lookup::Error.for(object, Scope)
		#
		# `Magic::Lookup::Error` is never raised internally and is meant
		# to be used by a class implementing the lookup logic.
		class Error < NameError
			def self.for object, lookup_class
				default_name = lookup_class.name_for object.class

				new "no #{lookup_class} found for #{object.class}, default name is #{default_name}",
						default_name, receiver: object
			end
		end
	end
end
