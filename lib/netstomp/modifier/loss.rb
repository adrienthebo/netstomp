require 'netstomp/modifier'

Netstomp::Modifier.add('loss') do |m|

  m.flag = '--loss PCT'

  m.extend(Netstomp::Modifier::ModifierUtils)

  m.desc = "Drop packets"

  m.define_parser do |arg|
    Integer(arg)
  end

  m.define_runner do |command, input, opts|
    puts "Discarding #{input}% of packets"
    specifier = [opts[:device], "root", nil]
    m.evaluate do
      Netstomp::Netem.loss(*specifier, input, 25).run(:noop => opts[:noop]) do
        system(command.join(" "))
      end
    end
  end
end

