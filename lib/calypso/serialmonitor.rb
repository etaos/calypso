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

require 'serialport'
require 'thread'

#
module Calypso
  # Calypso's serial controller
  class SerialMonitor
    # @return [String] Path to the serial device.
    attr_reader :portname
    # @return [Fixnum] Serial baud rate.
    attr_reader :baud
    # @return [Fixnum] Number of data bits per byte.
    attr_reader :databits
    # @return [Fixnum] Number of stop bits.
    attr_reader :stopbits
    # @return [Symbol] Connection parity.
    attr_reader :parity
    # @return [Array<String>] Array of data read from the serial port.
    attr_reader :data

    # Calypso application exit token.
    CALYPSO_EXIT = "calypso_exit".freeze

    # Create a new serial port controller.
    #
    # @param port [String] Path to the serial device.
    # @param baud [Fixnum] Serial baud rate.
    # @param databits [Fixnum] Number of data bits per byte.
    # @param stopbits [Fixnum] Number of stop bits.
    # @param parity [Symbol] Connection parity.
    def initialize(port, baud = 9600, databits = 8, stopbits = 1, parity = SerialPort::NONE)
      @port = SerialPort.new(port, baud, databits, stopbits, parity)
      @portname = port
      @baud = baud
      @databits = databits
      @stopbits = stopbits
      @parity = parity
      @data = nil
      @mutex = Mutex.new
    end

    # Monitor the serial port.
    #
    # @return [Boolean] Whether or not the application was manually stopped.
    def monitor
      running = true
      ary = []
      manual_stop = false

      thread = Thread.new do
        while running do
          begin
            input = gets
            puts input
            if input.nil?
              @mutex.synchronize {running = false}
              manual_stop = true
              Thread.stop
              break
            end

            input.chomp!
            @port.write input
            @port.flush
          rescue Exception => e
            puts e.message
            exit
          end
        end
      end

      while (data = @port.gets.chomp) do
        if data.eql? CALYPSO_EXIT then
          Thread.kill thread
          ary.push data
          break
        end

        puts data
        ary.push data
        break unless running
      end

      thread.join unless manual_stop
      @port.close
      @data = ary
      manual_stop
    end
  end
end

