# frozen_string_literal: true

$:.unshift File.expand_path('../lib', __FILE__)
require 'dok8s/version'

Gem::Specification.new do |s|
  s.name          = "dok8s"
  s.version       = Dok8s::VERSION
  s.authors       = ["Roman Almeida"]
  s.email         = ["post@romanalmeida.com"]
  s.homepage      = "http://github.com/nasmorn/dok8s"
  s.summary       = "Digital Ocean k8s deploy scripts"
  s.description   = "Digital Ocean k8s deploy scripts"
  s.license       = "MIT"

  s.files         = `git ls-files`.split("\n")
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ["lib"]

  s.required_ruby_version = ">= 2.7"

  s.add_dependency "rake"
end
