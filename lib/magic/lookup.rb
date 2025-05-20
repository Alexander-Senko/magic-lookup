# frozen_string_literal: true

require_relative 'lookup/version'

require 'memery'

module Magic
	# = Magic Lookup
	#
	# These are the steps to set up an automatic class inference:
	#
	# 1. Define a base class extending `Magic::Lookup`.
	# 2. Define `.name_for` method for that class implementing your
	#    lookup logic.
	# 3. From the base class, inherit classes to be looked up.
	#
	# Example:
	#
	#     class Scope
	#       extend Magic::Lookup
	#
	#       def self.name_for object_class
	#         object_class.name
	#             .delete_suffix('Model')
	#             .concat('Scope')
	#       end
	#     end
	#
	#     class MyScope < Scope
	#     end
	#
	#     Scope.for MyModel    # => MyScope
	#     Scope.for OtherModel # => nil
	module Lookup
		autoload :Error,      'magic/lookup/error'
		autoload :Namespaces, 'magic/lookup/namespaces'

		include Memery

		memoize def for object_class, namespace = nil
			descendants = self.descendants # cache
					.union([ self ]) # including self
					.reverse # most specific first

			object_class.ancestors
					.lazy # optimization
					.filter(&:name)
					.map { name_for _1 }
					.map { [ *namespace, _1 ] * '::' }
					.filter_map do |class_name|
						descendants.find { _1.name == class_name }
					end
					.first
		end

		prepend Namespaces

		def name_for(object_class) = raise NotImplementedError

		def descendants
			[
					*subclasses,
					*subclasses.flat_map(&__method__),
			]
		end
	end
end
