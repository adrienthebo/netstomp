module Netstomp
  class IPTables

    def initialize(chain, device, params)
      @chain  = chain
      @device = device
      @params = params
    end

    def add
      "iptables -I #{@chain} 1 --out-interface #{@device} #{@params}"
    end

    def delete
      "iptables -D #{@chain} 1"
    end

    def run(opts = {}, &block)
      intermittent = opts.delete(:intermittent)

      if intermittent
        run_intermittent(opts, &block)
      else
        run_once(opts, &block)
      end
    end

    def identifier
      id = "dev #{@device} #{@parent}"
      id << " handle #{@handle}" if @handle
      id
    end

    private

    def run_once
      execute(add, opts[:noop])
      block.call
    ensure
      execute(delete, opts[:noop])
    end

    def run_intermittent(opts, &block)
      thr = Thread.new { block.call }

      delay = multipass(90, 2)
      puts "delaying for #{delay} seconds before tampering"
      thr.join(delay)
      while thr.alive?
        begin
          execute(add, opts[:noop])
          delay = multipass(600, 4)
          puts("Tampering with traffic and delaying for #{delay} seconds")
          thr.join(delay)
        ensure
          puts("completed delay")
          execute(delete, opts[:noop])
        end
        delay = multipass(600, 4)
        puts("Quiescing and delaying for #{delay} seconds")
        thr.join(delay)
      end
    end

    def multipass(max, passes = 1)
      prng = Random.new
      rv = max
      passes.times { rv = prng.rand(rv) if rv > 0 }
      rv
    end

    def execute(cmd, noop)
      log(cmd)
      if !noop
        %x{#{cmd}}
      end
    end

    def log(str)
      puts "execute: #{str}"
    end


    def self.reset(device)
      new("OUTPUT", device, "-p tcp -j REJECT --reject-with tcp-reset")
    end

    def self.drop(device)
      new("OUTPUT", device, "-p tcp -j DROP")
    end
  end
end

module Netstomp
  class IPTablesInt < Netstomp::IPTables

    def run(opts = {}, &block)
    ensure
    end
  end
end
