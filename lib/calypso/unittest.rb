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

module Calypso
  class UnitTest
    attr_reader :name, :path, :mode, :hw, :hardware, :exec, :autorun

    ETAOS_BUILD_TARGETS = "all".freeze
    ETAOS_PREBUILD_TARGETS = "prepare".freeze
    ETAOS_CLEAN_TARGETS = "clean".freeze
    ETAOS_INSTALL_TARGETS = "modules_install".freeze

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

