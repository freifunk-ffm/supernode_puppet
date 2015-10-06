module Puppet::Parser::Functions

	newfunction(:ffmff_random_string, :type => :rvalue) do |args|
		require 'base64'

		size = args[0].to_i

		Base64.encode64(Random.new.bytes(size))
	end
end
