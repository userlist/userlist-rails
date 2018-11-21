lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'userlist/rails/version'

Gem::Specification.new do |spec|
  spec.name        = 'userlist-rails'
  spec.version     = Userlist::Rails::VERSION
  spec.authors     = ['Benedikt Deicke']
  spec.email       = ['benedikt@userlist.io']
  spec.homepage    = 'https://github.com/userlistio/userlist-rails'
  spec.summary     = 'Rails integration for Userlist.io'
  spec.license     = 'MIT'

  spec.files       = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 3.0'
  spec.add_dependency 'railties', '>= 3.0'
  spec.add_dependency 'userlist', '~> 0.1'

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'webmock', '~> 1.22'
end
