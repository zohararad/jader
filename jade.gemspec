# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "jade/version"

Gem::Specification.new do |s|
  s.name        = "jade"
  s.version     = Jade::VERSION
  s.authors     = ["Boris Staal"]
  s.email       = ["boris@roundlake.ru"]
  s.homepage    = ""
  s.summary     = %q{Server-side Jade compiler based on Tilt}
  s.description = %q{Jade is a high performance template engine heavily influenced by Haml and implemented with JavaScript for node.}

  s.rubyforge_project = "jade"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'execjs'
  s.add_dependency 'tilt'
  s.add_dependency 'sprockets'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rails', '>= 3.1'
  s.add_development_dependency 'pry'
end
