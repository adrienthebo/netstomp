require 'netstomp/iptables'

Netstomp::Modifier.add('drop') do |m|

  m.flag = '--drop'

  m.extend(Netstomp::Modifier::ModifierUtils)

  m.desc = "Drop output packets"

  m.define_parser { |arg| }

  m.define_runner do |command, input, opts|
    m.evaluate do
      Netstomp::IPTables.drop(opts[:device]).run(:noop => opts[:noop], :intermittent => true) do
        system(command.join(" "))
      end
    end
  end
end

