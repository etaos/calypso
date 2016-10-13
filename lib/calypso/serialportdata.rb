#
#   Calypso module - SerialPort wrapper
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

#
module Calypso
  # Serial port information wrapper.
  class SerialPortData
    # @return [String] Path to the serial device.
    attr_reader :port
    # @return [Fixnum] Serial baud rate.
    attr_reader :baud
    # @return [Fixnum] Number of data bits per byte.
    attr_reader :databits
    # @return [Fixnum] Number of stop bits.
    attr_reader :stopbits
    # @return [Symbol] Connection parity.
    attr_reader :parity

    # Create a new serial port controller.
    #
    # @param port [String] Path to the serial device.
    # @param baud [Fixnum] Serial baud rate.
    # @param databits [Fixnum] Number of data bits per byte.
    # @param stopbits [Fixnum] Number of stop bits.
    # @param parity [Symbol] Connection parity.
    def initialize(port, baud = 9600, databits = 8, stopbits = 1, parity = SerialPort::NONE)
      @port = port
      @baud = baud
      @databits = databits
      @stopbits = stopbits
      @parity = parity
    end
  end
end

