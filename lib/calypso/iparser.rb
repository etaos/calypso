#
#   Calypso parser interface
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

#
module Calypso
  # Parser interface.
  class IParser
    # @return [Hash] Hash of unit tests.
    attr_reader :tests
    # @return [Hash] Hash of available hardware.
    attr_reader :hardware

    # Create a new Parser.
    #
    # @param file [String] Path to the configuration file.
    def initialize(file)
      @tests = {}
      @hardware = {}
      @file = file
    end

    # Cruch data.
    #
    # @return [nil]
    def parse
    end

    protected
    # Set the hardware hash.
    #
    # @param hw [Hash] Hash of available hardware.
    # @return [nil]
    def set_hardware(hw)
      @hardware = hw
    end

    # Set the tests hash.
    #
    # @param tests [Hash] Hash of available tests.
    # @return [nil]
    def set_tests(tests)
      @tests = tests
    end
  end
end

