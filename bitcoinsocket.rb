require 'ostruct'

require './jsonsocket'

class BitcoinCharts < JSONSocket
    def initialize
        super("bitcoincharts.com", 27007)
    end

    def handle(hash)
        t = OpenStruct.new(hash)

        s = ""

        # XXX - make this less ugly if possible

        s << Time.at(t.timestamp).strftime("[%F %T]")
        s << " #{t.symbol.ljust(12)}"

        l, r = t.volume.split('.')
        r = r ? ".#{r.ljust(4)}" : " " * 5
        s << "#{l.rjust(10)}#{r} BTC @ "

        l, r  = t.price.split('.')
        r = r ? ".#{r.ljust(8)}" : " " * 9
        s << "#{l.rjust(6)}#{r} #{t.currency}"

        puts s
    end
end

BitcoinCharts.new.io_loop
