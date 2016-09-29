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

module Calypso
  class SerialMonitor
    attr_reader :portname, :baud, :databits, :stopbits, :parity
    CALYPSO_EXIT = "calypso_exit".freeze

    def initialize(port, baud = 9600, databits = 8, stopbits = 1, parity = SerialPort::NONE)
      @port = SerialPort.new(port, baud, databits, stopbits, parity)
      @portname = port
      @baud = baud
      @databits = databits
      @stopbits = stopbits
      @parity = parity

      @mutex = Mutex.new
    end

    def monitor
      running = true
      ary = []
      manual_stop = false

      thread = Thread.new do
        while running do
          input = gets
          if input.nil?
            @mutex.synchronize {running = false}
            manual_stop = true
            Thread.stop
            break
          end

          input.chomp!
          port.write input
          port.flush
        end
      end

      while (data = port.gets.chomp) do
        if data.eql? CALYPSO_EXIT then
          Thread.kill thread
          break
        end

        puts data
        ary.push data
        break unless running
      end

      thread.join
      puts "Test aborted by user" if manual_stop
      ary
    end

  end
end

