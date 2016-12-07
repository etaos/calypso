#
#   Calypso module
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

require 'pp'
require 'optparse'
require 'optparse/time'
require 'ostruct'

require 'calypso/version'
require 'calypso/hardware'
require 'calypso/version'
require 'calypso/parserproxy'

# Calypso base module
module Calypso
  class << self
    attr_reader :options

    # Start Calypso.
    #
    # @param args [Array] Argument list
    # @return [nil]
    def start(args)
      options = OpenStruct.new
      options.parser = nil
      options.config = nil
      options.path = Dir.pwd
      options.single = nil
      options.bare = false
      options.hardware = nil
      options.run_mode = :all
      options.tty_fix = false
      options.tty_fix = true if ENV['TTY_FIX'].eql? 'true'
      options.update = false

      parser = OptionParser.new do |p|
        p.banner = "Usage: calypso [options] -c [config]"
        p.separator ""
        p.separator "Specific options:"

        p.on('-y', '--yaml', "Parse configuration as YAML") do
          options.parser = :yaml
        end

        p.on('-u', '--update', "Update configuration files") do
          options.update = true
        end

        p.on('-b', '--bare', "Do not recompile ETA/OS before running the test") do
          options.bare = true
        end

        p.on('-f', '--tty-fix',
             'Enforce the correct TTY settings before trying to run a test') do
          options.tty_fix = true
        end

        p.on('-t [TESTID]', '--test [TESTID]',
             'Run a specific test') do |id|
          options.single = id
          options.run_mode = :single
        end

        p.on('-c [FILE]', '--config [FILE]',
             'Path to the test configuration') do |conf|
          options.config = conf
        end

        p.on('-H [hardware-id]', '--hardware [hardware-id]',
             'Run all tests configured for a specific MCU') do |hardware|
          options.hardware = hardware
          options.run_mode = :hardware
        end

        p.separator ""
        p.separator "Common options:"

        p.on_tail("-h", "--help", "Show this message") do
          puts p
          exit
        end

        p.on_tail("-v", "--version", "Print the Calypso version") do
          puts "Calypso #{Calypso::VERSION}"
          exit
        end
      end

      parser.parse!

      mandatory = [:config, :parser]
      missing = mandatory.select do |param|
        if options[param].nil? or options[param] == false
          param
        end
      end

      unless missing.empty?
        puts "Missing mandatory options!"
        puts ""
        puts parser
        exit
      end

      unless options.single.nil? or options.hardware.nil?
        puts "The options -t and -H cannot be used together!"
        puts ""
        puts parser
        exit
      end

      @options = options
      config = Calypso::ParserProxy.new(options.parser, options.config)
      config.parse

      if options.update
        Calypso.update(config, options)
        exit
      end

      case options.run_mode
      when :all
        Calypso.run(config, options)
      when :hardware
        Calypso.run_hardware(config, options, options.hardware)
      when :single
        Calypso.run_single(config, options)
      end
    end

    def update_hw(parser, options, hwid)
      hw = parser.hardware[hwid]
      tests = hw.tests

      tests.each do |test|
        puts "Updating #{test.name}"
        puts ""
        test.update
      end
    end

    def update(parser, options)
      hw = parser.hardware

      hw.each do |hwid, hwdata|
        Calypso.update_hw(parser, options, hwid)
      end
    end

    # Run a single test.
    #
    # @param parser [Calypso::ParserProxy] Configuration parser.
    # @param options [OpenStruct] Options passed to Calypso on the cmd line.
    # @return [nil]
    def run_single(parser, options)
      test = parser.tests[options.single]
      puts "Running test [#{test.name}]"
      
      Calypso.tty_fix(test.serial) if options.tty_fix
      test.execute
      puts "[#{test.name}]: #{test.success? ? 'OK' : 'FAIL'}"
    end

    # Run all tests for a specific piece of hardware.
    #
    # @param config [Calypso::ParserProxy] Configuration parser.
    # @param options [OpenStruct] Options passed to Calypso on the cmd line.
    # @param hwid [String] Hardware ID.
    # @return [nil]
    def run_hardware(config, options, hwid)
      hw = config.hardware[hwid]
      tests = hw.tests
      puts "Running #{hw.name} tests. Press enter to continue..."
      gets

      tests.each do |test|
        next unless test.autorun
        Calypso.tty_fix(test.serial) if options.tty_fix
        test.execute
        success = "successfully" if test.success?
        success = "unsuccessfully" unless test.success?
        puts ""
        puts "#{test.name} ran #{success}!"
        puts ""
      end

      puts "Unit test results:\n"
      tests.each do |test|
        next unless test.autorun
        puts "[#{test.name}]: #{test.success? ? 'OK' : 'FAIL'}"
      end
    end

    # Run all unit tests.
    #
    # @param parser [Calypso::ParserProxy] Configuration parser.
    # @param options [OpenStruct] Options passed to Calypso on the cmd line.
    # @return [nil]
    def run(parser, options)
      hw = parser.hardware

      hw.each do |hwid, hwdata|
        Calypso.run_hardware(parser, options, hwid)
      end
    end

    # Fix the serial TTY configuration.
    #
    # @param serial [Calypso::SerialPortData] Serial port data
    # @return [nil]
    def tty_fix(serial)
      fix_cmd = "stty 57600 raw ignbrk hup < #{serial.port}"
      system(fix_cmd)
    end
  end
end

