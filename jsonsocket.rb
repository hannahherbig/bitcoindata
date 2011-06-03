require 'socket'
require 'json'

class JSONSocket
    def initialize(*args)
        @socket = TCPSocket.new(*args)
        @recvq = []
    end

    def read
        begin
            ret = @socket.read_nonblock(8192)
        rescue IO::WaitReadable
            retry
        end

        ret.scan(/(.+\n?)/) do |m|
            line = m[0]

            # If the last line had no \n, add this one onto it.
            if @recvq[-1] and @recvq[-1][-1].chr != "\n"
                @recvq[-1] += line
            else
                @recvq << line
            end

            if @recvq[-1] and @recvq[-1][-1].chr == "\n"
                parse
            end
        end

        self
    end

    def parse
        @recvq.each do |line|
            line.chomp!

            line.gsub! /[^[:print:]]/, "" # remove any characters that aren't
                                          # printable.

            json = JSON.parse(line)

            handle json
        end

        @recvq.clear
    end

    def handle(*args)
        raise NotImplementedError, "handle method not implemented", caller
    end

    def poll
        ret = IO.select([@socket])

        return unless ret

        read unless ret[0].empty?

        self
    end

    def io_loop
        loop { poll }
    end
end
