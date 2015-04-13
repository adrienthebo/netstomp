require 'netstomp/modifier'

Netstomp::Modifier.add('corrupt') do |m|

  m.flag = '--corrupt PCT'

  m.extend(Netstomp::Modifier::ModifierUtils)

  m.desc = "Corrupt a percentage of packets"

  m.define_parser do |arg|
    Integer(arg)
  end

  m.define_runner do |command, input, opts|
    puts "Corrupting #{input}% of packets"
    specifier = [opts[:device], "root", nil]
    m.evaluate do
      Netstomp::Netem.corrupt(*specifier, input).run(:noop => opts[:noop]) do
        system(command.join(" "))
      end
    end
  end
end
