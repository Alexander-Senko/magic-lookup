# frozen_string_literal: true

require_relative 'lookup/version'

require 'memery'

module Magic
	module Lookup
		autoload :Error, 'magic/lookup/error'

		include Memery

		memoize def for object_class
			descendants = self.descendants # cache
					.reverse # most specific first

			object_class.ancestors
					.lazy # optimization
					.filter(&:name)
					.map { name_for _1 }
					.filter_map do |class_name|
						descendants.find { _1.name == class_name }
					end
					.first
		end

		def name_for(object_class) = raise NotImplementedError

		def descendants
			[
					*subclasses,
					*subclasses.flat_map(&__method__),
			]
		end
	end
end
