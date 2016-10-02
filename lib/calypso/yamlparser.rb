#
#   Calypso YAML parser
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

require 'yaml'

require 'calypso/iparser'
require 'calypso/hardware'
require 'calypso/unittest'
require 'calypso/serialportdata'

module Calypso
  class YAMLParser < IParser
    def initialize(file)
      super
    end

    def parse
      obj = YAML.load_file(@file)
      hardware = Hash.new
      tests = Hash.new

      obj['hardware'].each do |key, value|
        hw = Calypso::Hardware.new(key, value['name'], value['cpu'])
        hardware[key] = hw
      end

      obj['unit-tests'].each do |key, value|
        hw = hardware[value['hardware']]
        port = value['port']
        baud = value['baud']
        serial = Calypso::SerialPortData.new(port, baud)
        tst = Calypso::UnitTest.new(value, serial, hw)
        tests[key] = tst
	hw.add_test tst
      end

      set_hardware(hardware)
      set_tests(tests)
    end
  end
end

