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

require 'fileutils'

require 'calypso/serialmonitor'
require 'calypso/serialportdata'

module Calypso
  class UnitTest
    attr_reader :name, :path, :mode, :hw, :hardware, :exec

    ETAOS_BUILD_TARGETS = "all".freeze
    ETAOS_PREBUILD_TARGETS = "prepare".freeze
    ETAOS_CLEAN_TARGETS = "clean".freeze
    ETAOS_INSTALL_TARGETS = "modules_install".freeze

    def initialize(conf, serial, hw)
      @name = conf['value']
      @path = File.expand_path conf['path']
      @mode = conf['mode']
      @hw = hw
      @hardware = hw
      @exec = conf['execute']
      config = conf['config']
      @conf = "#{@path}/#{config}" unless conf.nil?
      @libdir = File.expand_path conf['libdir'] unless conf['libdir'].nil?
      @serial = serial
      @raw = conf
      @success = false
    end

    def execute
      system("make #{ETAOS_CLEAN_TARGETS}")

      FileUtils.copy(@conf, './.config')
      system("make #{ETAOS_PREBUILD_TARGETS}")
      system("make #{ETAOS_BUILD_TARGETS}")
      system("make #{ETAOS_INSTALL_TARGETS} INSTALL_MOD_PATH=#{@libdir}")
      system("make -f scripts/Makefile.calypso TEST=#{@path}")
      sp = Calypso::SerialMonitor.new(@serial.port)
      manual_stop = sp.monitor

      if manual_stop
	print "Did the test run succesfully? [y/n]: "
	reply = gets
	@success = true if reply.eql? 'y' or reply.eql? 'Y'
      else
	@success = true
      end
    end

    def success?
      @success
    end
  end
end

