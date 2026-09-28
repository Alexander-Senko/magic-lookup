# frozen_string_literal: true

# Enhanced table view for expressions
#
# rubocop:disable Layout/SpaceBeforeFirstArg
#
# Enhanced nested method chains
#
# rubocop:disable Layout/MultilineMethodCallIndentation

require 'support/scope'

module Magic
	module Lookup
		RSpec.describe Namespaces do
			subject { base_class }

			let(:base_class) { Class.new DummyScope }

			it { is_expected.to be { it < described_class } }

			describe Error do
				subject { described_class }

				describe '.for' do
					context 'with configured namespaces' do
						its_result [], NamespacedScope do
							is_expected.to have_attributes to_s: /default name is Namespace::ArrayScope/
						end
					end
				end
			end

			describe '.namespaces' do
				subject { stub_const 'ArrayScope', Class.new(base_class) }

				before { base_class.namespaces += [] } # keep the underlying constant class untouched

				its_result { is_expected.to eq [ nil ] } # default

				it 'can be set' do
					expect { receiver.namespaces = %i[ Namespace ] }
							.to change(subject, :call)
									.from([ nil ])
									.to %i[ Namespace ]
				end

				it 'can be updated' do
					expect { receiver.namespaces << :Namespace }
							.to change(subject, :call)
									.from([ nil ])
									.to   [ nil, :Namespace ]
				end

				describe 'inheritance' do
					it 'uses base class namespaces by default' do
						expect { receiver.namespaces << :Namespace }
								.to change(base_class, :namespaces)
										.from([ nil ])
										.to   [ nil, :Namespace ]
					end
				end
			end

			describe '.for' do
				before { stub_const            'ArrayScope', Class.new(base_class) }
				before { stub_const 'Namespace::ArrayScope', Class.new(base_class) }

				context 'with configured namespaces' do
					before { receiver.namespaces += [ Namespace ] }

					its_result(Array)      { is_expected.to be Namespace::ArrayScope }
					its_result(Array, nil) { is_expected.to be            ArrayScope }

					it 'isn’t cached' do
						expect { receiver.namespaces -= [ Namespace ] }
								.to change { subject[Array] }
										.from(Namespace::ArrayScope)
										.to              ArrayScope
					end

					context 'without matching scopes in the namespace' do
						before { receiver.namespaces = [ 'OtherNamespace' ] }

						its_result(Array) { is_expected.to be_nil }

						context 'with a fallback' do
							before { receiver.namespaces = [ nil, 'OtherNamespace' ] }

							its_result(Array) { is_expected.to be ArrayScope }
						end
					end
				end
			end

			describe '.match?' do
				before { stub_const            'ArrayScope', Class.new(base_class) }
				before { stub_const 'Namespace::ArrayScope', Class.new(base_class) }

				context 'with configured namespaces' do
					subject { Namespace::ArrayScope }

					before { receiver.namespaces += [ Namespace ] }

					its_result(Array) { is_expected.to be true }

					context 'with an explicit namespace' do
						subject { ArrayScope }

						its_result(Array, nil) { is_expected.to be true }
					end

					it 'isn’t cached' do
						expect { receiver.namespaces -= [ Namespace ] }
								.to change { subject[Array] }
										.from(true)
										.to   false
					end

					context 'without matching scopes in the namespace' do
						subject { ArrayScope }

						before { receiver.namespaces = [ 'OtherNamespace' ] }

						its_result(Array) { is_expected.to be false }

						context 'with a fallback' do
							before { receiver.namespaces = [ nil, 'OtherNamespace' ] }

							its_result(Array) { is_expected.to be true }
						end
					end
				end
			end

			describe '.name_match?' do
				before { stub_const            'ArrayScope', Class.new(base_class) }
				before { stub_const 'Namespace::ArrayScope', Class.new(base_class) }

				context 'with configured namespaces' do
					subject { Namespace::ArrayScope }

					before { receiver.namespaces += [ Namespace ] }

					its_result(Array) { is_expected.to be true }

					context 'with an explicit namespace' do
						subject { ArrayScope }

						its_result(Array, nil) { is_expected.to be true }
					end

					it 'isn’t cached' do
						expect { receiver.namespaces -= [ Namespace ] }
								.to change { subject[Array] }
										.from(true)
										.to   false
					end

					context 'without matching scopes in the namespace' do
						subject { ArrayScope }

						before { receiver.namespaces = [ 'OtherNamespace' ] }

						its_result(Array) { is_expected.to be false }

						context 'with a fallback' do
							before { receiver.namespaces = [ nil, 'OtherNamespace' ] }

							its_result(Array) { is_expected.to be true }
						end
					end
				end
			end
		end
	end
end
