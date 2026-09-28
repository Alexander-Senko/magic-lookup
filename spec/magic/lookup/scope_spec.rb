# frozen_string_literal: true

# Enhanced table view for expressions
#
# rubocop:disable Layout/SpaceBeforeFirstArg

require 'support/scope'

module Magic
	RSpec.describe Lookup::Scope do
		subject { base_module }

		let :base_module do
			Module.new.tap do
				it.include described_class
			end
		end

		before do
			for name in class_names do
				stub_const name, Class.new.tap {
					it.include base_module
				}
			end
		end

		shared_context :nameable do
			subject { stub_const 'Scopable', base_module }
		end

		describe '.for' do
			let(:class_names) { %w[ User Guest ] }

			its_result(UserScope) { is_expected.to be User }

			context 'without matching classes' do
				let(:class_names) { [] }

				its_result(AdminScope) { is_expected.to be_nil }
			end

			context 'with multiple matching classes' do
				before { stub_const 'Admin', Class.new(User) }

				it 'raises a lookup error' do
					expect { subject[GenericScope] }
							.to raise_error Lookup::Error, "multiple classes found for #{GenericScope}"
				end

				it_behaves_like :nameable do
					it 'raises a lookup error' do
						expect { subject[GenericScope] }
								.to raise_error Lookup::Error, "multiple Scopable classes found for #{GenericScope}"
					end
				end

				context 'when resolvable by name' do
					its_result( UserScope) { is_expected.to be  User }
					its_result(AdminScope) { is_expected.to be Admin }
				end

				context 'when inherited' do
					let(:class_names) { %w[ User ] }

					its_result(GenericScope) { is_expected.to be Admin }
				end
			end
		end

		describe '.classes' do
			let(:class_names) { %w[ User Guest ] }

			its_result { is_expected.to be_a Array }
			its_result { is_expected.to all be_a Class }
			its_result { is_expected.to all be { it < self } }

			its_result { is_expected.to contain_exactly User, Guest }

			context 'with an empty scope' do
				let(:class_names) { [] }

				its_result { is_expected.to eq [] }
			end

			context 'with inherited classes' do
				before { stub_const 'Admin', Class.new(User) }

				its_result { is_expected.to contain_exactly User, Guest, Admin }
			end

			context 'with unrelated classes' do
				before { stub_const 'UnrelatedClass', Class.new }

				its_result { is_expected.to contain_exactly User, Guest }
			end

			context 'with singleton classes' do
				before { User.singleton_class }

				its_result { is_expected.to contain_exactly User, Guest }
			end
		end
	end
end
