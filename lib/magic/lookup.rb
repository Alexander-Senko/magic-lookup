# frozen_string_literal: true

require_relative 'lookup/version'
require_relative 'lookup/rails' if defined? Rails

require 'memery'
require 'active_support/core_ext/string/inflections'

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
		autoload :Scope,      'magic/lookup/scope'

		include Memery

		memoize def for object_class, namespace = nil
			object_class.ancestors
					.lazy # optimization
					.filter(&:name)
					.map { namespaced_name_for it, namespace }
					.filter_map(&:safe_constantize)
					.grep(..self)
					.first
		end

		prepend Namespaces

		def name_for(object_class) = raise NotImplementedError

		def namespaced_name_for object_class, namespace = nil
			[ *namespace, name_for(object_class) ] * '::'
		end

		def match?(...)
			self.for(...) == self
		end

		alias_method :=~, :match?

		def name_match?(...)
			namespaced_name_for(...) == name
		end
	end
end
