require 'optparse'
require 'netstomp/modifier'

module Netstomp
  class Application

    def initialize
    end

    def parse(argv)
      parser.order(argv)
    end

    def run(argv)
      command = parse(argv)

      modifier_options.each_pair do |key, value|
        Netstomp::Modifier.get(key).run(command, value, global_options)
      end
    end

    def parser
      @parser ||= OptionParser.new do |opts|
        opts.banner = "Usage: #{File.basename($0)} --device DEV --command CMD"

        opts.on("-d", "--device DEV", "The device to stomp on") do |value|
          global_options[:device] = value
        end

        Netstomp::Modifier.all.values.each do |modifier|
          opts.on(modifier.flag, modifier.desc) do |value|
            modifier_options[modifier.name] = value
          end
        end

        opts.on("-h", "--help", "Print this help") do
          puts opts
          exit
        end
      end
    end
    private :parser

    def global_options
      @global_options ||= {}
    end

    def modifier_options
      @modifier_options||= {}
    end
  end
end
