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

module Calypso
  class << self
    attr_reader :options

    def start(args)
      options = OpenStruct.new
      options.parser = nil
      options.config = nil
      options.path = Dir.pwd
      options.single = nil
      options.bare = false

      parser = OptionParser.new do |p|
        p.banner = "Usage: calypso [options] -c [config]"
        p.separator ""
        p.separator "Specific options:"

        p.on('-y', '--yaml', "Parse configuration as YAML") do
          options.parser = :yaml
        end

        p.on('-b', '--bare', "Do not recompile ETA/OS before running the test") do
          options.bare = true
        end

        p.on('-t [TESTID]', '--test [TESTID]',
             'Run a specific test') do |id|
          options.single = id
        end

        p.on('-c [FILE]', '--config [FILE]',
             'Path to the test configuration') do |conf|
          options.config = conf
        end

        p.separator ""
        p.separator "Common options:"

        p.on_tail("-h", "--help", "Show this message") do
          puts p
          exit
        end

        p.on_tail("-v", "--version", "Print the Zeno version") do
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

      @options = options
      config = Calypso::ParserProxy.new(options.parser, options.config)
      config.parse
      Calypso.run_single(config, options.single) unless options.single.nil?
      Calypso.run(config, options) if options.single.nil?
    end

    def run_single(parser, testid)
      test = parser.tests[testid]
      puts "Running test [#{test.name}]"
      
      test.execute
      puts "[#{test.name}]:\t\t#{test.success? ? 'OK' : 'FAIL'}"
    end

    def run(parser, options)
      hw = parser.hardware

      hw.each do |k, v|
        print "Running #{v.name} tests. Press enter to continue..."
        gets
        tests = v.tests
        tests.each do |test|
          next unless test.autorun
          test.execute
          success = "succesfully" if test.success?
          sucess = "unsuccessfully" unless test.success?
          puts ""
          puts "#{test.name} ran #{success}!"
          puts ""
        end

        # Now print a report
        puts "Unit test results:\n"
        tests.each do |test|
          next unless test.autorun
          puts "[#{test.name}]: #{test.success? ? 'OK' : 'FAIL'}"
        end
      end
    end
  end
end

