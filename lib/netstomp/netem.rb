require 'netstomp/qdisc'

module Netstomp
  class Netem < Netstomp::QDisc
    def initialize(device, parent, handle, params)
      super("netem", device, parent, handle, params)
    end

    def self.corrupt(device, parent, handle, pct)
      new(device, parent, handle, "corrupt #{pct}%")
    end

    def self.duplicate(device, parent, handle, pct)
      new(device, parent, handle, "duplicate #{pct}%")
    end

    def self.loss(device, parent, handle, pct, correlation = nil)
      params = "loss #{pct}%"
      params << " #{correlation}%" if correlation
      new(device, parent, handle, params)
    end
  end
end
