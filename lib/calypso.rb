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

require "calypso/version"

module Calypso
  class << self
    def start(args)
      options = OpenStruct.new
      options.yaml = false
      options.config = nil
      options.path = Dir.pwd
      parse_lang_set = false

      parser = OptionParser.new do |p|
        p.banner = "Usage: calypso [options] -c [config]"
        p.separator ""
        p.separator "Specific options:"

        p.on('-y', '--yaml', "Parse configuration as YAML") do
          parse_lang_set = true
          options.yaml = true
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

      mandatory = [:config]
      missing = mandatory.select do |param|
        if options[param].nil? or options[param] == false
          param
        end
      end

      missing.push :parser unless parse_lang_set

      unless missing.empty?
        puts "Missing mandatory options!"
        puts ""
        puts parser
        exit
      end
    end
  end
end

