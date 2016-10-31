# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'calypso/version'

Gem::Specification.new do |spec|
  spec.name          = "calypso"
  spec.version       = Calypso::VERSION
  spec.authors       = ["Michel Megens"]
  spec.email         = ["dev@bietje.net"]
  spec.license       = 'GPLv3'

  spec.summary       = %q{Embedded test automation.}
  spec.description   = %q{Automate tests for embedded system based on a specific configuration.}
  spec.homepage      = "http://etaos.bietje.net/calypso"

  spec.bindir        = "bin"
  spec.executables   = ['calypso']
  spec.require_paths = ["lib"]
  spec.files         = ['bin/calypso',
                        'lib/calypso.rb',
                        'lib/calypso/version.rb',
                        'lib/calypso/hardware.rb',
                        'lib/calypso/iparser.rb',
                        'lib/calypso/kbuild.rb',
                        'lib/calypso/parserproxy.rb',
                        'lib/calypso/serialmonitor.rb',
                        'lib/calypso/serialportdata.rb',
                        'lib/calypso/unittest.rb',
                        'lib/calypso/yamlparser.rb']

  spec.add_development_dependency "bundler", ">= 1.10.0"
  spec.add_development_dependency "rake", ">= 10.0.0"
  spec.add_development_dependency "rspec", "3.4.0"
  spec.add_development_dependency "serialport", "1.3.0"
end
