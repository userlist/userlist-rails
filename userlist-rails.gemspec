lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'userlist/rails/version'

Gem::Specification.new do |spec|
  spec.name        = 'userlist-rails'
  spec.version     = Userlist::Rails::VERSION
  spec.authors     = ['Benedikt Deicke']
  spec.email       = ['benedikt@userlist.com']
  spec.homepage    = 'https://github.com/userlistio/userlist-rails'
  spec.summary     = 'Rails integration for Userlist'
  spec.license     = 'MIT'

  spec.files       = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.4'

  spec.add_dependency 'activesupport', '>= 5.0'
  spec.add_dependency 'railties', '>= 5.0'
  spec.add_dependency 'userlist', '~> 0.6'

  spec.metadata = { 'rubygems_mfa_required' => 'true' }
end
