module Puppet::Parser::Functions

	newfunction(:ffmff_random_string) do |args|
		require 'base64'

		size = args[0]

		Base64.encode64(Random.new.bytes(size))
	end
end
