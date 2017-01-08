# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_week/version'

Gem::Specification.new do |spec|
  spec.name          = "activeweek"
  spec.version       = ActiveWeek::VERSION
  spec.authors       = ["Yuya Takeyama"]
  spec.email         = ["sign.of.the.wolf.pentagram@gmail.com"]

  spec.summary       = %q{ActiveSupport based Object Oriented API represents week}
  spec.description   = %q{ActiveSupport based Object Oriented API represents week}
  spec.homepage      = "https://github.com/yuya-takeyama/activeweek"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "~> 4.2.7.1"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"#, "~> 10.0"
end
