# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require_relative 'lib/clearsale_clean/version'

Gem::Specification.new do |spec|
  spec.name          = 'clearsale_clean'
  spec.version       = ClearsaleClean::VERSION
  spec.authors       = ['Diogo Gouveia', 'Augusto C S Martins']
  spec.email         = ['diogo.gouveia@repassa.com.br', 'augusto@repassa.com.br']
  spec.summary       = 'Gem clean for Clearsale'
  spec.description   = 'Description for clearsale-clean.'
  spec.metadata['allowed_push_host'] = "Set to 'http://mygemserver.com'"
  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.add_dependency 'activesupport', '~> 6.0', '>= 6.0.3.2'
  spec.add_dependency 'builder', '~> 3.2', '>= 3.2.4'
  spec.add_dependency 'savon', '~> 2.12', '>= 2.12.1'

  spec.add_development_dependency 'byebug', '~> 11.1', '>= 11.1.3'
  spec.add_development_dependency 'rspec', '~> 3.9'
  spec.add_development_dependency 'rubocop', '~> 0.88.0'
  spec.add_development_dependency 'simplecov', '~> 0.18.5'
  spec.add_development_dependency 'vcr', '~> 6.0'
  spec.add_development_dependency 'webmock', '~> 3.8.3'
end
