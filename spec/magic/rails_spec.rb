# frozen_string_literal: true

# Enhanced nested method chains
#
# rubocop:disable Layout/MultilineMethodCallIndentation

require 'rails_helper'
require 'magic/rails'

module Magic
	RSpec.describe 'Rails integration' do
		describe 'helpers' do
			subject { Magic }

			describe '.eager_load' do
				let(:app)         { Rails.application }
				let(:autoloaders) { Rails.autoloaders.main }
				let(:app_dir)     { app.root/'app' }
				let(:eager_load)  { false } # development environment

				before { Rails.application.config.eager_load = eager_load }
				before { allow(autoloaders).to receive :eager_load_dir }

				it 'eagerly loads a provided existing scope' do
					subject.call :controller

					expect(autoloaders).to have_received(:eager_load_dir)
							.with app_dir / 'controllers'
				end

				it 'eagerly loads existing scopes only' do
					subject.call :models, :views, :controllers

					expect(autoloaders).to have_received(:eager_load_dir)
							.exactly(2).times # models & controllers
				end

				it 'doesn’t try to load a provided non-existing scope' do
					subject.call :view

					expect(autoloaders).not_to have_received :eager_load_dir
				end

				it 'does nothing with no scopes provided' do
					subject.call

					expect(autoloaders).not_to have_received :eager_load_dir
				end

				context 'with eager loading enabled' do
					let(:eager_load) { true } # test/production environment

					it 'does nothing' do
						subject.call :models

						expect(autoloaders).not_to have_received :eager_load_dir
					end
				end

				context 'with an engine' do
					let(:engine) { Engine.instance }
					let(:app)    { engine }

					class Engine < Rails::Engine
						config.root = 'spec/rails/engine'
					end

					it 'accepts an optional `engine:` parameter' do
						subject.(:models, engine:)

						expect(autoloaders).to have_received(:eager_load_dir)
								.with app_dir / 'models'
					end
				end
			end
		end
	end
end
