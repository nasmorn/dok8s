require "dok8s/railtie" if defined?(Rails::Railtie)
require "dok8s/engine" if defined?(Rails::Railtie)

module Dok8s
  def self.root
    File.dirname __dir__
  end
end
