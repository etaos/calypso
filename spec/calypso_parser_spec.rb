require 'spec_helper'

describe Calypso::ParserProxy do
  it 'can be initialised' do
    file = "spec/yaml-test.yml"
    parser = Calypso::ParserProxy.new(:yaml, file)
    expect(parser).not_to be nil
  end

  it 'can parse a YAML file' do
    file = "spec/yaml-test.yml"
    parser = Calypso::ParserProxy.new(:yaml, file)
    parser.parse
    hardware = parser.hardware
    tests = parser.tests
    expect(hardware['ard-mega'].name).eql? "Arduino Mega"
    expect(tests['stress-test'].name).eql? "Stress test"
    expect(tests['stress-test'].hardware).to be hardware['ard-mega']
  end
end
