$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
require 'view_models/version'

Gem::Specification.new do |s|
  s.name          = "view_models"
  s.version       = ViewModels::VERSION.dup
  s.authors       = ["Florian Hanke", "Kaspar Schiess", "Niko Dittmann", "Beat Richartz"]
  s.date          = Time.now.strftime("%Y-%m-%d")
  s.email         = "beat.richartz@gmail.com"
  s.summary       = "The missing R to the Rails MVC"
  s.description   = "The missing R to the Rails MVC"
  s.extensions    = 'ext/mkrf_conf.rb'
  s.homepage      = 'https://github.com/beatrichartz/view_models'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.licenses      = ['MIT']

  s.add_dependency             'actionpack',          '>= 3.1'

  s.add_development_dependency 'rails',               '>= 3.1'
  s.add_development_dependency 'jquery-rails'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'rake',                '>= 0.8.7'
  s.add_development_dependency 'aruba'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'RedCloth'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'appraisal',           '~> 0.5'
  s.add_development_dependency 'bundler',             '>= 1.0'
  s.add_development_dependency 'cucumber-rails'#,      '~> 1.3' #bundler is not friends with some cucumber versions
  s.add_development_dependency 'capybara',            '~> 1'
  s.add_development_dependency 'factory_girl_rails',  '~> 1'
  s.add_development_dependency 'factory_girl',        '~> 2'
  s.add_development_dependency 'slim-rails',          '>= 1.0'
  s.add_development_dependency 'rspec',               '~> 2'
  s.add_development_dependency 'rspec-rails',         '~> 2'

  if RUBY_ENGINE == 'rbx'
    s.add_development_dependency "rubysl", "~> 2.0"
    s.add_development_dependency "rubysl-test-unit", '~> 2.0'
    s.add_development_dependency "racc",   "~> 1.4"
  end
end
