# frozen_string_literal: true

require "bundler/gem_tasks"

$LOAD_PATH.unshift File.expand_path("lib", __dir__)

Dir.glob("lib/tasks/**/*.rake").each { |r| load r }

task default: :spec
