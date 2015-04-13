require 'netstomp/netem'
require 'benchmark'

module Netstomp
  class Modifier

    @modifiers = {}

    def self.add(name, &block)
      @modifiers[name] = Modifier.new(name, &block)
    end

    def self.get(name)
      @modifiers[name]
    end

    def self.all
      @modifiers
    end

    attr_reader :name

    attr_accessor :desc

    attr_accessor :flag

    attr_accessor :arg

    def initialize(name, &block)
      @name = name
      block.call(self)
    end

    def define_parser(&block)
      @parser = block
    end

    def define_runner(&block)
      @runner = block
    end

    def run(command, value, opts)
      input = @parser.call(value)
      @runner.call(command, input, opts)
    end

    module ModifierUtils

      def evaluate(&block)
        time = ::Benchmark.realtime do
          puts "---"
          block.call
          puts "---"
        end
        puts "Command ran in %.2f seconds" % time
      end
    end
  end

  require 'netstomp/modifier/corrupt'
  require 'netstomp/modifier/reset'
  require 'netstomp/modifier/drop'
end
