# frozen_string_literal: true

namespace :magentic_bazaar do
  task :bootstrap do
    require "active_record"
    require "magentic_bazaar"

    # Stub RailsMultistore for standalone use (no Rails engine needed)
    module RailsMultistore
      module Model; end
    end

    MagenticBazaar.configuration ||= MagenticBazaar::Configuration.new
    MagenticBazaar.configuration.multistore_enabled = false

    # Connect to standalone SQLite database
    db_path = File.expand_path("../../db/standalone.sqlite3", __dir__)
    ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: db_path)

    # Run migrations
    migration_paths = [File.expand_path("../../db/migrate", __dir__)]
    ActiveRecord::MigrationContext.new(migration_paths).migrate

    # Load app classes (models, services) without Rails autoloading, skip jobs
    app_root = File.expand_path("../../app", __dir__)
    Dir.glob("#{app_root}/**/*.rb").sort.reject { |f| f.include?("/jobs/") }.each { |f| require f }
  end

  desc "Run the ingestion pipeline to process documents in doc/ingest"
  task ingest: :bootstrap do
    pipeline = MagenticBazaar::IngestPipeline.new
    ingestion = pipeline.call
    puts "Ingestion complete: #{ingestion.documents_processed}/#{ingestion.documents_count} documents processed"
  end

  desc "Show ingestion status and document counts"
  task status: :bootstrap do
    ingestions = MagenticBazaar::Ingestion.count
    documents = MagenticBazaar::Document.count
    skills = MagenticBazaar::Skill.count
    uml_diagrams = MagenticBazaar::UmlDiagram.count

    puts "MagenticBazaar Status"
    puts "---------------------"
    puts "Ingestions:   #{ingestions}"
    puts "Documents:    #{documents}"
    puts "Skills:       #{skills}"
    puts "UML Diagrams: #{uml_diagrams}"

    last = MagenticBazaar::Ingestion.order(created_at: :desc).first
    if last
      puts ""
      puts "Last ingestion:"
      puts "  Status:    #{last.status}"
      puts "  Processed: #{last.documents_processed}/#{last.documents_count}"
      puts "  Git SHA:   #{last.git_sha}"
      puts "  Date:      #{last.created_at}"
    end
  end
end
