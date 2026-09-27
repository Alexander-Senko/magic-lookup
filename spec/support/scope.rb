# frozen_string_literal: true

class AbstractScope
	extend Magic::Lookup
end

class DummyScope < AbstractScope
	def self.name_for(object_class) = "#{object_class}Scope"
end

class NamespacedScope < DummyScope
	self.namespaces = %i[
			OtherNamespace
			Namespace
	]
end
