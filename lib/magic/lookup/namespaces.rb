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

			class << self
				private

				def with_namespaces method_name
					returns = if method_name.end_with? '?' # boolean
						:any?
					else
						:first
					end

					define_method method_name do |object_class, *namespaces|
						return super object_class, *namespaces unless
								namespaces.empty?

						self.namespaces
								.reverse # recently added first
								.lazy    # optimization
								.filter_map { super object_class, it }
								.instance_eval(&returns)
					end
				end
			end

			def namespaces = @namespaces ||
					if superclass.respond_to? :namespaces
						superclass.namespaces
					else
						@namespaces = [ nil ]
					end

			with_namespaces :for
			with_namespaces :namespaced_name_for
			with_namespaces :match?
			with_namespaces :name_match?
		end
	end
end
