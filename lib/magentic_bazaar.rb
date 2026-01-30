# frozen_string_literal: true

require "magentic_bazaar/version"
require "magentic_bazaar/configuration"
require "magentic_bazaar/engine"

module MagenticBazaar
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  def self.gem_root
    Pathname.new(File.expand_path("../..", __FILE__))
  end
end
