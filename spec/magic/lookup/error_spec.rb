# frozen_string_literal: true

require 'support/scope'

module Magic
	module Lookup
		RSpec.describe Error do
			describe '.for' do
				its_result [], DummyScope do
					is_expected.to be_instance_of described_class
				end

				its_result [], DummyScope do
					is_expected.to be_a StandardError
				end

				its_result [], DummyScope do
					is_expected.to have_attributes to_s: /no DummyScope found/,
							name: 'ArrayScope', receiver: []
				end

				its_result [], DummyScope do
					is_expected.to have_attributes to_s: /default name is ArrayScope/
				end
			end
		end
	end
end
