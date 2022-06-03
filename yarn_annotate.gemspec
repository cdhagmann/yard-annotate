$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'yarn_annotate/version'

Gem::Specification.new do |s|
  s.name     = 'yarn-annotate'
  s.version  = ::YarnAnnotate::VERSION
  s.authors  = ['Christopher Hagmann']
  s.email    = ['cdhagmann@gmail.com']
  s.homepage = 'http://github.com/cdhagmann/yarn-annotate'

  s.description = s.summary = 'Automatically annotate your code with Yardoc.'
  s.platform = Gem::Platform::RUBY

  s.add_dependency 'parser', '~> 2.6'
  s.add_dependency 'gli', '~> 2.0'

  s.executables << 'yarn-annotate'

  s.require_path = 'lib'
  s.files = Dir['{lib,spec}/**/*', 'Gemfile', 'README.md', 'Rakefile', 'yarn_annotate.gemspec']
end
