#
#   Calypso parser proxy
#   Copyright (C) 2016  Michel Megens <dev@bietje.net>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

require 'calypso/iparser'
require 'calypso/yamlparser'

#
module Calypso
  # Proxy class for the Calypso configuration parser.
  class ParserProxy
    # Create a new parser proxy instance.
    #
    # @param type [Symbol] Parser type.
    # @param file [String] Path to configuration file.
    def initialize(type, file)
      @file = File.expand_path(file)
      @parser = case type
                when :yaml
                  YAMLParser.new(@file)
                else
                  nil
                end
    end

    # Parse the config file.
    def parse
      @parser.parse
    end

    # Get the available hardware.
    #
    # @return [Hash] Hash of the available hardware.
    def hardware
      @parser.hardware
    end

    # Get a hash containing all tests.
    #
    # @return [Hash] All available unit tests.
    def tests
      @parser.tests
    end
  end
end

