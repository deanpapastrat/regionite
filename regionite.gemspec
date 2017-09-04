# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'regionite/version'

Gem::Specification.new do |spec|
  spec.name          = 'regionite'
  spec.version       = Regionite::VERSION
  spec.authors       = ['Dean Papastrat']
  spec.email         = ['dean.g.papastrat@gmail.com']

  spec.summary       = 'Get countries in a region, or the region a country is in.'
  spec.homepage      = 'https://github.com/deanpapastrat/regionite'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
