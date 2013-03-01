Gem::Specification.new do |spec|
  spec.name         = 'carbon-agent'
  spec.summary      = 'A client to send metrics to a carbon server'
  spec.version      = '0.0.4.6'
  spec.date         = Time.new.strftime('%F')
  spec.author       = 'Brian Stevens'
  spec.email        = 'brian.stevens@dataporters.com'
  spec.files        = Dir['bin/*'] + Dir['lib/**'] + Dir['test/**'] 
  spec.files        << 'Rakefile'
  spec.require_path = 'lib'
  spec.bindir       = 'bin'
  spec.executables  = 'carbon-agent'
  spec.test_files   = Dir['test/*.rb']
end
