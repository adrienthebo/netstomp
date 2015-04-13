lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name        = 'netstomp'
  s.version     = '0.1.0dev'
  s.platform    = Gem::Platform::RUBY

  s.authors     = 'Adrien Thebo'
  s.email       = 'adrien@somethingsinistral.net'
  s.homepage    = 'http://github.com/adrienthebo/netstomp'
  s.summary     = 'Run commands under adverse network conditions'
  s.description = <<-DESCRIPTION
    Netstomp is a stress testing framework for network based applications. It degrades
    network performance while running applications using tc and tc-netem.
  DESCRIPTION

  s.license  = 'Apache-2.0'

  s.add_development_dependency 'rspec', '~> 3.1'
  s.add_development_dependency 'yard', '~> 0.8'

  s.files        = Dir.glob('{bin,lib,spec}/**/*')
  s.require_path = 'lib'
  s.bindir       = 'bin'
  s.executables  = 'netstomp'

  s.test_files   = Dir.glob("spec/**/*_spec.rb")
end
