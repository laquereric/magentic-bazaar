# frozen_string_literal: true

module MagenticBazaar
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Install MagenticBazaar engine: copies initializer and migrations, creates directories"

      def copy_initializer
        template "initializer.rb", "config/initializers/magentic_bazaar.rb"
      end

      def copy_migrations
        rake "magentic_bazaar:install:migrations"
      end

      def create_directories
        %w[doc/ingest doc/ingested doc/uml doc/skills doc/human].each do |dir|
          empty_directory dir
        end
      end

      def display_readme
        say ""
        say "MagenticBazaar installed successfully!", :green
        say ""
        say "  1. Run `rails db:migrate` to create tables"
        say "  2. Configure stores in config/initializers/magentic_bazaar.rb"
        say "  3. Drop files in doc/ingest/ and run:"
        say "       MagenticBazaar::IngestJob.perform_later"
        say "     or synchronously:"
        say "       MagenticBazaar::IngestPipeline.new.call"
        say ""
      end
    end
  end
end
