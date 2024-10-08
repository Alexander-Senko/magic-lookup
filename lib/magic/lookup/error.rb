# frozen_string_literal: true

module Magic
	module Lookup
		class Error < NameError
			def self.for object, lookup_class
				default_name = lookup_class.name_for object.class

				new "no #{lookup_class} found for #{object.class}, default name is #{default_name}",
						default_name, receiver: object
			end
		end
	end
end
