module Netstomp
  class QDisc

    attr_reader :qdisc

    attr_reader :device

    attr_reader :parent

    attr_reader :handle

    attr_reader :params

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

    def identifier
      id = "dev #{@device} #{@parent}"
      id << " handle #{@handle}" if @handle
      id
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

  end
end
