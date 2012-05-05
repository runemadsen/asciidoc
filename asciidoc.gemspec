# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "asciidoc"
  s.version     = "0.0.2"
  s.authors     = ["Rune Madsen"]
  s.email       = ["rune@runemadsen.com"]
  s.homepage    = ""
  s.summary     = %q{A gem to parse AsciiDoc documents into Ruby models and convert to HTML / PDF }
  s.description = %q{A gem to parse AsciiDoc documents into Ruby models and convert to HTML / PDF}

  s.rubyforge_project = "asciidoc"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "nokogiri"
end
