#
#   Calypso module - Kbuild representation
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

module Calypso
  class Kbuild
    attr_reader :conf

    ETAOS_BUILD_TARGETS = "all".freeze
    ETAOS_PREBUILD_TARGETS = "prepare".freeze
    ETAOS_CLEAN_TARGETS = "clean".freeze
    ETAOS_INSTALL_TARGETS = "modules_install".freeze

    def initialize(conf, test_path)
      @conf = conf
      @path = test_path
      FileUtils.copy(@conf, "#{Dir.pwd}/.config")
    end

    def clean
      system("make #{ETAOS_CLEAN_TARGETS}")
    end

    def build
      system("make #{ETAOS_PREBUILD_TARGETS}")
      system("make #{ETAOS_BUILD_TARGETS}")
    end

    def install_modules(libdir)
      system("make #{ETAOS_INSTALL_TARGETS} INSTALL_MOD_PATH=#{libdir}")
    end

    def build_test(targets)
      system("make -f scripts/Makefile.calypso TARGETS=\"#{targets}\" TEST=#{@path}")
    end

    def build_all
      clean
      build
      install_modules
      build_app
      nil
    end
  end
end

