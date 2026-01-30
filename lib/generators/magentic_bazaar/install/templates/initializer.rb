# frozen_string_literal: true

MagenticBazaar.configure do |config|
  # Directory paths (relative to Rails.root)
  # config.ingest_dir   = "doc/ingest"
  # config.ingested_dir = "doc/ingested"
  # config.uml_dir      = "doc/uml"
  # config.skills_dir   = "doc/skills"
  # config.human_dir    = "doc/human"

  # Tesseract OCR binary path (for image ingestion)
  # config.tesseract_path = "tesseract"

  # Background processing
  config.async      = true
  config.queue_name = :magentic_bazaar

  # Multistore integration (requires rails-multistore gem and store adapters)
  config.multistore_enabled = true
  # config.multistore_stores = [
  #   { name: :search, type: :elasticsearch, url: "http://localhost:9200" },
  #   { name: :docs,   type: :marklogic,     url: "http://localhost:8000" }
  # ]

  # Error handling
  # config.error_handler = ->(error, context) {
  #   Rails.logger.error("[MagenticBazaar] #{context}: #{error.message}")
  # }
end
