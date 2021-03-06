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

require 'calypso/serialmonitor'
require 'calypso/serialportdata'
require 'calypso/kbuild'

#
module Calypso
  # Unit test model class
  class UnitTest
    # @return [String] Unit test name.
    attr_reader :name
    # @return [String] Unit test path.
    attr_reader :path
    # @return [Symbol] Unit test mode.
    attr_reader :mode
    # @return [Calypso::Hardware] Unit test hardware.
    attr_reader :hw
    # @return [Calypso::Hardware] Unit test hardware.
    attr_reader :hardware
    # @return [String] Unit test build and execution targets.
    attr_reader :exec
    # @return [Boolean] Whether or not the test should be ran automatically.
    attr_reader :autorun
    # @return [SerialPortData] Information about the serial port used by the test
    attr_reader :serial

    # Create a new UnitTest model.
    #
    # @param conf [Hash] Unit test configuration values.
    # @param serial [Calypso::SerialPortData] Serial port information.
    # @param hw [Calypso::Hardware] Unit test hardware.
    def initialize(conf, serial, hw)
      @name = conf['name']
      @path = File.expand_path conf['path']
      @mode = conf['mode'] == 'manual' ? :manual : :auto
      @hw = hw
      @hardware = hw
      @exec = conf['execute']
      config = conf['config']
      @conf = "#{@path}/#{config}" unless conf.nil?
      @libdir = File.expand_path conf['libdir'] unless conf['libdir'].nil?
      @serial = serial
      @raw = conf
      @success = false
      @autorun = conf['autorun']
      @compare_file = conf['compare']
    end

    # Execute the unit test.
    #
    # @return [Boolean] Whether or not the test executed succesfully.
    def execute
      kbuild = Kbuild.new(@conf, @path)

      unless Calypso.options.bare
        kbuild.clean
        kbuild.build
        kbuild.install_modules(@libdir)
      end
      
      kbuild.build_test(@exec)
      sp = Calypso::SerialMonitor.new(@serial.port)
      manual_stop = sp.monitor

      if manual_stop or @mode == :manual
        print "Did the test run succesfully? [y/n]: "
        reply = gets.chomp
        @success = true if reply.eql? 'y' or reply.eql? 'Y'
      else
        @success = compare(sp)
      end
    end

    # Update the unit test configuration file.
    #
    # @return [nil]
    def update
      kbuild = Kbuild.new(@conf, @path)
      kbuild.prepare
      kbuild.save_config
    end

    # Check if the test ran succesfully.
    #
    # @return [Boolean] Whether or not the test executed succesfully.
    def success?
      @success
    end

    private
    def compare(serial)
      return if @compare_file.nil?
      path = "#{@path}/#{@compare_file}"
      data = serial.data
      idx = 0

      file = File.open path
      while (line = file.gets) do
        line.chomp!
        return false unless line.eql? data[idx]
        idx += 1
      end

      return true
    end
  end
end

