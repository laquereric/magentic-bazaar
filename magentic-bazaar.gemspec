# frozen_string_literal: true

require_relative "lib/magentic_bazaar/version"

Gem::Specification.new do |spec|
  spec.name        = "magentic-bazaar"
  spec.version     = MagenticBazaar::VERSION
  spec.authors     = ["Eric Laquer"]
  spec.email       = ["eric@laquer.com"]
  spec.homepage    = "https://github.com/laquereric/magentic-bazaar"
  spec.summary     = "Document ingestion pipeline as a Rails engine"
  spec.description = "Transforms source documentation into UML diagrams, " \
                     "technical skill summaries, and human-readable docs. " \
                     "Integrates with rails-multistore for multi-store persistence."
  spec.license     = "MIT"

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"]   = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir[
    "{app,config,db,lib,skills}/**/*",
    "MIT-LICENSE",
    "Rakefile",
    "README.md"
  ]

  spec.required_ruby_version = ">= 3.3.6"

  spec.add_dependency "rails", ">= 7.0"
  spec.add_dependency "activejob", ">= 7.0"
  spec.add_dependency "activerecord", ">= 7.0"
  spec.add_dependency "rails-multistore", "~> 0.1"
  spec.add_dependency "pdf-reader", "~> 2.0"

  spec.add_development_dependency "rspec-rails", "~> 6.0"
  spec.add_development_dependency "sqlite3"
end
