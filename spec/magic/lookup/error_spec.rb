# frozen_string_literal: true

class Scope
	extend Magic::Lookup

	def self.name_for(object_class) = "#{object_class}Scope"
end

module Magic
	module Lookup
		RSpec.describe Error do
			describe '.for', :method do
				its([[], Scope]) do
					is_expected.to be_instance_of described_class
				end

				its([[], Scope]) do
					is_expected.to be_a StandardError
				end

				its([[], Scope]) do
					is_expected.to have_attributes to_s: /no Scope found/,
							name: 'ArrayScope', receiver: []
				end
			end
		end
	end
end
