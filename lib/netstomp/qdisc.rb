module Netstomp
  class QDisc

    def initialize(qdisc, device, parent, handle, params)
      @qdisc  = qdisc
      @device = device
      @parent = parent
      @handle = handle
      @params = params
    end

    def add
      "tc qdisc add #{identifier} #{@qdisc} #{@params}"
    end

    def delete
      "tc qdisc delete #{identifier}"
    end

    def run(opts = {}, &block)
      execute(add, opts[:noop])
      block.call
    ensure
      execute(delete, opts[:noop])
    end

    private

    def execute(cmd, noop)
      log(cmd)
      if !noop
        %x{#{cmd}}
      end
    end

    def log(str)
      puts "execute: #{str}"
    end

    def identifier
      id = "dev #{@device} #{@parent}"
      id << " handle #{@handle}" if @handle
      id
    end
  end
end
