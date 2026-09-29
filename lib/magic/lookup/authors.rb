# frozen_string_literal: true

begin
	require 'rubygems/author'
rescue LoadError
	require_relative '../../../vendor/gems/rubygems-author/lib/rubygems/author'
end

module Magic
	module Lookup
		class Author < Gem::Author # :nodoc:
			new(
					name:   'Alexander Senko',
					email:  'Alexander.Senko@gmail.com',
					github: 'Alexander-Senko',
			)
		end
	end
end
