# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "jader/version"

Gem::Specification.new do |s|
  s.name        = "jader"
  s.version     = Jader::VERSION
  s.authors     = ["Zohar Arad", "Boris Staal"]
  s.email       = ["zohar@zohararad.com" "boris@roundlake.ru"]
  s.homepage    = "https://github.com/zohararad/jader"
  s.summary     = %q{JST and Rails views compiler for Jade templates}
  s.description = %q{Share your Jade views between client and server, eliminate code duplication and make your single-page app SEO friendly}

  s.rubyforge_project = "jader"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'tilt'
  s.add_dependency 'sprockets'
  s.add_dependency 'execjs'
  s.add_development_dependency 'rspec', '~> 3.1'
  s.add_development_dependency 'rspec-rails', '~> 3.1'
  s.add_development_dependency 'rspec-activemodel-mocks', '~> 1.0'
  s.add_development_dependency 'rails', '~> 3.2'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'yard'
end
