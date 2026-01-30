# MagenticBazaar

Rails engine for document ingestion — transforms source documents (Markdown, PDF, images) into UML diagrams, technical skill summaries, and human-readable documentation. Integrates with [rails-multistore](https://github.com/laquereric/rails-multistore) for multi-store persistence.

## Features

- **Multi-format ingestion** — Markdown, PDF (via pdf-reader), and JPEG/JPG (via Tesseract OCR)
- **UML diagram generation** — Intelligent content analysis selects from 10 PlantUML diagram types (class, sequence, activity, state machine, component, deployment, use case, inheritance, composition, conceptual)
- **Skill summaries** — Generates structured technical summaries with metadata, content analysis, and UML classification
- **Human-readable docs** — Creates cross-referenced documentation with links to UML diagrams and skill files
- **Multistore integration** — Documents, Skills, and UML Diagrams auto-push to configured data stores via rails-multistore
- **Background processing** — ActiveJob support for async ingestion
- **Undo support** — Full reverse workflow restores originals and removes generated artifacts

## Installation

Add to your Gemfile:

```ruby
gem "magentic-bazaar", git: "https://github.com/laquereric/magentic-bazaar.git"
gem "rails-multistore", git: "https://github.com/laquereric/rails-multistore.git"
```

Run the install generator:

```bash
bundle install
rails generate magentic_bazaar:install
rails db:migrate
```

This creates:
- `config/initializers/magentic_bazaar.rb` — configuration file
- `doc/ingest/` — drop zone for source documents
- `doc/ingested/` — archive of processed originals
- `doc/uml/` — generated PlantUML diagrams
- `doc/skills/` — generated skill summaries
- `doc/human/` — generated human-readable docs
- Database tables for documents, skills, UML diagrams, and ingestion tracking

## Configuration

Edit `config/initializers/magentic_bazaar.rb`:

```ruby
MagenticBazaar.configure do |config|
  # Directory paths (relative to Rails.root)
  config.ingest_dir   = "doc/ingest"
  config.ingested_dir = "doc/ingested"
  config.uml_dir      = "doc/uml"
  config.skills_dir   = "doc/skills"
  config.human_dir    = "doc/human"

  # Tesseract OCR binary path (for image ingestion)
  config.tesseract_path = "tesseract"

  # Background processing
  config.async      = true
  config.queue_name = :magentic_bazaar

  # Multistore integration
  config.multistore_enabled = true
  config.multistore_stores = [
    { name: :search, type: :elasticsearch, url: "http://localhost:9200" },
    { name: :docs,   type: :marklogic,     url: "http://localhost:8000" }
  ]
end
```

## Usage

### Ingest documents

Drop files into `doc/ingest/`, then run:

```ruby
# Async (via ActiveJob)
MagenticBazaar::IngestJob.perform_later

# Synchronous
MagenticBazaar::IngestPipeline.new.call
```

For each file, the pipeline:
1. Extracts text content (Markdown, PDF, or OCR)
2. Analyzes content against the UML glossary to classify diagram type
3. Generates a PlantUML diagram (`.puml`)
4. Generates an Anthropic skill-format summary (`.md`)
5. Generates human-readable documentation (`.md`)
6. Archives the original to `doc/ingested/`
7. Creates database records and pushes to configured multistore stores

### Undo ingestion

```ruby
# Async
MagenticBazaar::IngestJob.perform_later("undo")

# Synchronous
MagenticBazaar::UndoPipeline.new.call
```

### Query records

```ruby
MagenticBazaar::Document.ingested
MagenticBazaar::Document.pending

# Via multistore (queries all configured stores)
MagenticBazaar::Document.multistore_query("search term")
MagenticBazaar::Skill.multistore_query("UML")
```

## Architecture

### Models

| Model | Description |
|-------|-------------|
| `MagenticBazaar::Document` | Source document record with extracted content |
| `MagenticBazaar::Skill` | Generated technical skill summary |
| `MagenticBazaar::UmlDiagram` | Generated PlantUML diagram |
| `MagenticBazaar::Ingestion` | Batch tracking for ingest/undo runs |

All models except Ingestion include `RailsMultistore::Model` and push to configured stores on commit.

### Services

| Service | Purpose |
|---------|---------|
| `Extractors::MarkdownExtractor` | Reads Markdown files |
| `Extractors::PdfExtractor` | Extracts text from PDFs |
| `Extractors::ImageExtractor` | OCR via Tesseract |
| `Analyzers::UmlAnalyzer` | Classifies content into UML diagram types |
| `Analyzers::DocumentInsightsAnalyzer` | Extracts sections, key points, technical terms |
| `Generators::UmlGenerator` | Produces PlantUML source for 10 diagram types |
| `Generators::SkillGenerator` | Produces Anthropic skill-format summaries |
| `Generators::HumanDocGenerator` | Produces human-readable documentation |
| `UmlGlossaryLoader` | Parses the UML glossary reference data |
| `IngestPipeline` | Orchestrates the forward ingestion workflow |
| `UndoPipeline` | Orchestrates the undo workflow |

## UML Diagram Types

The analyzer selects the best diagram type based on document content:

- **Class Diagram** — OOP concepts, interfaces, classes
- **Inheritance Hierarchy** — Generalization, specialization
- **Composition/Aggregation** — Part-whole relationships
- **Use Case Diagram** — User personas, system interactions
- **Sequence Diagram** — Message flows, interactions
- **Activity Diagram** — Workflows, processes
- **State Machine Diagram** — States, transitions
- **Component Diagram** — System architecture
- **Deployment Diagram** — Infrastructure, hardware
- **Conceptual Overview** — General-purpose (default)

## Requirements

- Ruby >= 3.3.6
- Rails >= 7.0
- [Tesseract](https://github.com/tesseract-ocr/tesseract) (optional, for image OCR): `brew install tesseract`

## License

MIT — see [MIT-LICENSE](MIT-LICENSE).
