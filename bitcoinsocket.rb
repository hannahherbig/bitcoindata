require 'ostruct'

require './jsonsocket'

class BitcoinCharts < JSONSocket
    def initialize
        super("bitcoincharts.com", 27007)
    end

    def handle(hash)
        t = OpenStruct.new(hash)

        # XXX - make this less ugly if possible

        printf Time.at(t.timestamp).strftime("[%F %T]")
        printf " #{t.symbol.ljust(12)}"

        l, r = t.volume.split('.')
        r = r ? ".#{r.ljust(4)}" : " " * 5
        printf "#{l.rjust(10)}#{r} BTC @ "

        l, r  = t.price.split('.')
        r = r ? ".#{r.ljust(8)}" : " " * 9
        puts "#{l.rjust(6)}#{r} #{t.currency}"
    end
end

BitcoinCharts.new.io_loop
