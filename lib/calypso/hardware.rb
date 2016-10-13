#
#   Calypso module - Unit test hardware
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
  # Calypso hardware model.
  class Hardware
    # @return [String] Hardware ID.
    attr_reader :id
    # @return [String] Hardware name.
    attr_reader :name
    # @return [String] CPU name.
    attr_reader :cpu
    # @return [Array] An array of Calypso::UnitTest
    attr_reader :tests

    # Create a new Calypso::Hardware object.
    #
    # @param id [String] Hardware ID.
    # @param name [String] Hardware name.
    # @param cpu [String] CPU name (or MCU for the matter of it).
    def initialize(id, name, cpu)
      @id = id
      @name = name
      @cpu = cpu
      @tests = []
    end

    # Add a new test.
    #
    # @param test [Calypso::UnitTest] Test to add.
    # @return [Array] The new array of [Calypso::UnitTest].
    def add_test(test)
      @tests.push test
    end
  end
end

