#
#   Calypso module - Unit test
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

module Calypso
  class UnitTest
    attr_reader :name, :path, :mode, :hw, :hardware, :exec

    def initialize(name, path, mode, hw, cmds)
      @name = name
      @path = File.expand_path path
      @mode = mode
      @hw = hw
      @hardware = hw
      @exec = cmds
    end

    def execute
      false
    end
  end
end

