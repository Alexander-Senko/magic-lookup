# frozen_string_literal: true

# Enhanced table view for expressions
#
# rubocop:disable Layout/SpaceBeforeFirstArg

require 'support/scope'

module Magic
	RSpec.describe Lookup do
		subject { base_class }

		let(:base_class) { Class.new DummyScope }

		describe '.for' do
			before do
				allow(base_class).to receive(:name_for)
						.with(kind_of Module)
						.and_call_original
			end

			it 'passes `Module`s to `.name_for`' do
				subject[Array]

				expect(base_class).to have_received(:name_for)
						.with(kind_of Module)
						.at_least(1).time
			end

			context 'without `.name_for` explicitly defined' do
				let(:base_class) { AbstractScope }

				it { expect { subject[Array] }.to raise_error NotImplementedError }
			end

			context 'without scopes defined' do
				its_result(Array) { is_expected.to be_nil }
			end

			context 'without matching scopes defined' do
				before { stub_const 'ArrayDecorator', Class.new(base_class) }

				its_result(Array) { is_expected.to be_nil }
			end

			context 'when a class with a matching name doesn’t inherit from this one' do
				before { stub_const 'ArrayScope', Class.new }

				its_result(Array) { is_expected.to be_nil }
			end

			context 'with a matching scope' do
				before { stub_const 'ArrayScope', Class.new(base_class) }

				its_result(Array) { is_expected.to be ArrayScope }

				context 'when matching with itself' do
					subject { ArrayScope }

					its_result(Array) { is_expected.to be ArrayScope }
				end
			end

			describe 'autoloading' do
				before do
					stub_const 'Scope',
							base_class
					stub_const 'Autoloadable',
							Module.new {
								autoload :ArrayScope, 'fixtures/autoloadable/array_scope'
							}
				end

				its_result(Array, 'Autoloadable') { is_expected.to be Autoloadable::ArrayScope }

				example 'the target isn’t eagerly loaded' do
					expect(Autoloadable).not_to be_const_defined :ARRAY_SCOPE
				end
			end

			describe 'inheritance' do
				before { stub_const 'EnumerableScope', Class.new(base_class) }

				its_result(Array) { is_expected.to be EnumerableScope }

				context 'with several matches' do
					before { stub_const 'ArrayScope', Class.new(parent_class) }

					context 'when siblings' do
						let(:parent_class) { base_class }

						its_result(Array) { is_expected.to be ArrayScope }
					end

					context 'when inherited' do
						let(:parent_class) { EnumerableScope }

						its_result(Array) { is_expected.to be ArrayScope }
					end
				end
			end

			describe 'namespaces' do
				before { stub_const            'ArrayScope', Class.new(base_class) }
				before { stub_const 'Namespace::ArrayScope', Class.new(base_class) }

				its_result(Array, 'Namespace') { is_expected.to be Namespace::ArrayScope }

				context 'when target class is namespaced' do
					context 'when matching class is of the same namespace' do
						before { stub_const 'Enumerator::LazyScope', Class.new(base_class) }

						its_result(Enumerator::Lazy) { is_expected.to be Enumerator::LazyScope }
					end

					context 'when matching class is of another namespace' do
						before { stub_const 'EnumeratorScope', Class.new(base_class) }

						its_result(Enumerator::Lazy) { is_expected.to be EnumeratorScope }
					end
				end

				context 'when matching classes are namespaced' do
					before { def base_class.name_for(object_class) = "Scope::#{object_class}" }

					before { stub_const 'Scope::Array', Class.new(base_class) }

					its_result(Array) { is_expected.to be Scope::Array }

					context 'when target class is namespaced' do
						context 'when matching class is of the same namespace' do
							before { stub_const 'Scope::Enumerator::Lazy', Class.new(base_class) }

							its_result(Enumerator::Lazy) { is_expected.to be Scope::Enumerator::Lazy }
						end

						context 'when matching class is of another namespace' do
							before { stub_const 'Scope::Enumerator', Class.new(base_class) }

							its_result(Enumerator::Lazy) { is_expected.to be Scope::Enumerator }
						end
					end
				end
			end
		end
	end
end
