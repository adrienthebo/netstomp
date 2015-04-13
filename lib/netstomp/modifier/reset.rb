require 'netstomp/iptables'

Netstomp::Modifier.add('reset') do |m|

  m.flag = '--reset'

  m.extend(Netstomp::Modifier::ModifierUtils)

  m.desc = "Drop output packets and send a TCP reset"

  m.define_parser { |arg| }

  m.define_runner do |command, input, opts|
    m.evaluate do
      Netstomp::IPTables.reset(opts[:device]).run(:noop => opts[:noop], :intermittent => true) do
        system(command.join(" "))
      end
    end
  end
end

