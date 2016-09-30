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

module Calypso
  class SerialPortData
    attr_reader :port, :baud, :databits, :stopbits, :parity

    def initialize(port, baud = 9600, databits = 8, stopbits = 1, parity = SerialPort::NONE)
      @port = port
      @baud = baud
      @databits = databits
      @stopbits = stopbits
      @parity = parity
    end
  end
end

