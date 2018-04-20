
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_record/associations_counter/version'

Gem::Specification.new do |spec|
  spec.name          = 'activerecord-associations-counter'
  spec.version       = ActiveRecord::AssociationsCounter::VERSION
  spec.authors       = ['Masahiko Ashizawa']
  spec.email         = ['aileron.cc@gmail.com']

  spec.summary       = 'Yet Another N+1 COUNT Query Killer for ActiveRecord'
  spec.description   = 'Yet Another N+1 COUNT Query Killer for ActiveRecord'
  spec.homepage      = 'https://github.com/aileron-inc/activerecord-associations-counter'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'mysql2'
  spec.add_development_dependency 'postgres'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'sqlite3'
end
