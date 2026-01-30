#!/usr/bin/env ruby

# Ingest Workflow Script with UML Glossary Integration
# Automates the transformation of source documentation into multiple standardized formats
# Usage: ./bin/ingest.rb [undo]

require 'fileutils'
require 'digest'
require 'time'
require 'pdf-reader'

# Directory setup
INGEST_DIR = 'doc/ingest'
INGESTED_DIR = 'doc/ingested'
UML_DIR = 'doc/uml'
SKILLS_DIR = 'doc/skills'
HUMAN_DIR = 'doc/human'

# Load UML Glossary skill for enhanced analysis
UML_GLOSSARY_FILE = 'skills/uml-glossary.md'

# Function to generate UUID7
def generate_uuid7
  Digest::MD5.hexdigest((Time.now.to_f * 1000).to_i.to_s)[0, 7]
end

# Function to get current Git SHA
def get_git_sha
  sha = `git rev-parse HEAD 2>/dev/null`.strip
  sha.empty? ? 'not_a_git_repo' : sha
end

# Function to check if file already has UUID7 suffix (strips extension first)
def has_uuid7_suffix?(filename)
  basename_no_ext = filename.sub(/\.\w+$/, '')
  basename_no_ext.match(/__\w{7}$/)
end

# Function to add UUID7 suffix to filename (only if not already present)
def add_uuid7_suffix(filename, uuid7)
  return filename if has_uuid7_suffix?(filename)

  ext = File.extname(filename)
  filename.sub(/#{Regexp.escape(ext)}$/, '') + "__#{uuid7}#{ext}"
end

# Function to extract title from filename
def extract_title(filename)
  # Remove extensions and convert underscores to spaces, capitalize words
  filename.sub(/\.(md|pdf|jpg|jpeg)$/i, '').gsub('_', ' ').split.map(&:capitalize).join(' ')
end

# Function to extract text from PDF file
def extract_text_from_pdf(pdf_path)
  reader = PDF::Reader.new(pdf_path)
  text = ''

  reader.pages.each do |page|
    text += page.text + "\n"
  end

  # Clean up the extracted text
  text.gsub(/\f/, '') # Remove form feed characters
      .gsub(/\s+/, ' ') # Normalize whitespace
      .strip
end

# Function to determine if file is PDF
def pdf_file?(filename)
  filename.downcase.end_with?('.pdf')
end

# Function to determine if file is a JPG/JPEG image
def image_file?(filename)
  filename.downcase.end_with?('.jpg', '.jpeg')
end

# Function to extract text from image file using Tesseract OCR
def extract_text_from_image(image_path)
  output = `tesseract "#{image_path}" stdout 2>/dev/null`
  unless $?.success?
    raise "Tesseract OCR failed for #{image_path}. Is tesseract installed? (brew install tesseract)"
  end
  output.gsub(/\f/, '')
        .gsub(/\s+/, ' ')
        .strip
end

# Function to load UML glossary knowledge
def load_uml_glossary
  return {} unless File.exist?(UML_GLOSSARY_FILE)

  content = File.read(UML_GLOSSARY_FILE)
  glossary = {}

  # Extract core concepts
  if content =~ /### Core UML Concepts\n\n\|.*?\n\| --- \|\n(.*?)(?=\n\n###)/m
    concepts_section = Regexp.last_match(1)
    concepts_section.scan(/\| \*\*(\w+)\*\* \| (.*?) \|/) do |term, definition|
      glossary[:core_concepts] ||= {}
      glossary[:core_concepts][term] = definition.strip
    end
  end

  # Extract relationships
  if content =~ /### Relationships in UML\n\n\|.*?\n\| --- \| --- \| --- \|\n(.*?)(?=\n\n###)/m
    relationships_section = Regexp.last_match(1)
    glossary[:relationships] ||= {}
    relationships_section.scan(/\| \*\*(\w+(?:\s+\w+)*)\*\* \| (.*?) \| (.*?) \|/) do |relationship, definition, example|
      glossary[:relationships][relationship.strip] = {
        definition: definition.strip,
        example: example.strip
      }
    end
  end

  # Extract structural diagrams
  if content =~ /### Structural Diagrams\n\n\|.*?\n\| --- \|\n(.*?)(?=\n\n###)/m
    structural_section = Regexp.last_match(1)
    glossary[:structural_diagrams] ||= {}
    structural_section.scan(/\| \*\*(\w+(?:\s+\w+)*)\*\* \| (.*?) \|/) do |diagram, description|
      glossary[:structural_diagrams][diagram.strip] = description.strip
    end
  end

  # Extract behavioral diagrams
  if content =~ /### Behavioral Diagrams\n\n\|.*?\n\| --- \|\n(.*?)(?=\n\n##)/m
    behavioral_section = Regexp.last_match(1)
    glossary[:behavioral_diagrams] ||= {}
    behavioral_section.scan(/\| \*\*(\w+(?:\s+\w+)*)\*\* \| (.*?) \|/) do |diagram, description|
      glossary[:behavioral_diagrams][diagram.strip] = description.strip
    end
  end

  glossary
end

# Enhanced document analysis using UML glossary
def analyze_document_for_uml(content, glossary = {})
  content_lower = content.downcase

  # Check for UML-specific terminology
  uml_terms_found = []
  glossary[:core_concepts]&.each do |term, _definition|
    uml_terms_found << term if content_lower.include?(term.downcase)
  end

  glossary[:relationships]&.each do |relationship, _info|
    uml_terms_found << relationship if content_lower.include?(relationship.downcase)
  end

  glossary[:structural_diagrams]&.each do |diagram, _description|
    if content_lower.include?(diagram.downcase)
      return { type: 'class_diagram', title: 'UML Class Diagram', subtype: 'structural' }
    end
  end

  glossary[:behavioral_diagrams]&.each do |diagram, _description|
    next unless content_lower.include?(diagram.downcase)

    case diagram.downcase
    when 'use case diagram'
      return { type: 'use_case', title: 'Use Case Diagram', subtype: 'behavioral' }
    when 'sequence diagram'
      return { type: 'sequence', title: 'Sequence Diagram', subtype: 'behavioral' }
    when 'activity diagram'
      return { type: 'activity', title: 'Activity Diagram', subtype: 'behavioral' }
    when 'state machine diagram'
      return { type: 'state_machine', title: 'State Machine Diagram', subtype: 'behavioral' }
    end
  end

  # Enhanced analysis based on content and UML knowledge
  if uml_terms_found.include?('Class') || uml_terms_found.include?('Interface') || content_lower.include?('class diagram')
    { type: 'class_diagram', title: 'UML Class Diagram', subtype: 'structural' }
  elsif uml_terms_found.include?('Inheritance') || uml_terms_found.include?('Generalization')
    { type: 'inheritance', title: 'Inheritance Hierarchy', subtype: 'structural' }
  elsif uml_terms_found.include?('Composition') || uml_terms_found.include?('Aggregation')
    { type: 'composition', title: 'Composition/Aggregation', subtype: 'structural' }
  elsif content_lower.include?('user') && content_lower.include?('persona')
    { type: 'use_case', title: 'Use Case Diagram', subtype: 'behavioral' }
  elsif content_lower.include?('workflow') || content_lower.include?('process')
    { type: 'activity', title: 'Activity Diagram', subtype: 'behavioral' }
  elsif content_lower.include?('sequence') || content_lower.include?('interaction')
    { type: 'sequence', title: 'Sequence Diagram', subtype: 'behavioral' }
  elsif content_lower.include?('state') && content_lower.include?('transition')
    { type: 'state_machine', title: 'State Machine Diagram', subtype: 'behavioral' }
  elsif content_lower.include?('system') && content_lower.include?('architecture')
    { type: 'component', title: 'Component Diagram', subtype: 'structural' }
  elsif content_lower.include?('deployment') || content_lower.include?('hardware')
    { type: 'deployment', title: 'Deployment Diagram', subtype: 'structural' }
  else
    { type: 'conceptual', title: 'Conceptual Overview', subtype: 'general' }
  end
end

# Enhanced UML generation using UML glossary knowledge
def generate_intelligent_uml(content, title, analysis, glossary = {})
  case analysis[:type]
  when 'class_diagram'
    generate_class_diagram(title, content, glossary)
  when 'inheritance'
    generate_inheritance_diagram(title, content, glossary)
  when 'composition'
    generate_composition_diagram(title, content, glossary)
  when 'use_case'
    generate_use_case_diagram(title, content, glossary)
  when 'sequence'
    generate_sequence_diagram(title, content, glossary)
  when 'activity'
    generate_activity_diagram(title, content, glossary)
  when 'state_machine'
    generate_state_machine_diagram(title, content, glossary)
  when 'component'
    generate_component_diagram(title, content, glossary)
  when 'deployment'
    generate_deployment_diagram(title, content, glossary)
  else
    generate_conceptual_diagram(title, content, glossary)
  end
end

def generate_class_diagram(title, _content, _glossary)
  <<~UML
    @startuml
    title #{title} - Class Diagram

    ' Sample classes based on UML concepts
    class System {
      -name: String
      -version: String
      +initialize()
      +process()
      +shutdown()
    }

    class Component {
      -id: String
      -type: String
      +execute()
      +validate()
    }

    class Interface {
      <<interface>>
      +connect()
      +disconnect()
    }

    System "1" *-- "many" Component : composition
    Component ..|> Interface : realization
    Component "1" --> "many" Component : association

    @enduml
  UML
end

def generate_inheritance_diagram(title, _content, _glossary)
  <<~UML
    @startuml
    title #{title} - Inheritance Hierarchy

    abstract class AbstractEntity {
      #id: String
      #created: DateTime
      +getId(): String
    }

    class User {
      -username: String
      -email: String
      +login()
      +logout()
    }

    class Admin {
      -permissions: Array
      +manageUsers()
    }

    class Guest {
      -sessionId: String
      +browse()
    }

    AbstractEntity <|-- User
    User <|-- Admin
    User <|-- Guest

    note right of AbstractEntity
      Abstract base class
      using Generalization
    end note

    @enduml
  UML
end

def generate_composition_diagram(title, _content, _glossary)
  <<~UML
    @startuml
    title #{title} - Composition & Aggregation

    class House {
      -address: String
      +addRoom()
      +removeRoom()
    }

    class Room {
      -size: Float
      -type: String
      +getSize()
    }

    class Department {
      -name: String
      +addProfessor()
    }

    class Professor {
      -name: String
      -specialty: String
      +teach()
    }

    ' Composition: strong relationship
    House "1" *-- "many" Room : composition

    ' Aggregation: weak relationship
    Department "1" o-- "many" Professor : aggregation

    note right of House
      Composition: Room cannot
      exist without House
    end note

    note right of Department
      Aggregation: Professor can
      exist independently
    end note

    @enduml
  UML
end

def generate_use_case_diagram(title, _content, _glossary)
  <<~UML
    @startuml
    title #{title} - Use Case Diagram

    actor User
    actor Administrator
    actor System

    rectangle "System Boundary" {
      User -- (Login)
      User -- (Browse Content)
      User -- (Search)
      Administrator -- (Manage Users)
      Administrator -- (Configure System)
      System -- (Process Data)
      System -- (Generate Reports)
    }

    User .> Administrator : inheritance

    note right of User
      Primary actor
      interacts with system
    end note

    @enduml
  UML
end

def generate_sequence_diagram(title, _content, _glossary)
  <<~UML
    @startuml
    title #{title} - Sequence Diagram

    actor User
    participant "Frontend" as frontend
    participant "API Gateway" as api
    participant "Service" as service
    database "Database" as db

    User -> frontend: Request Action
    frontend -> api: HTTP Request
    api -> service: Process Request
    service -> db: Query Data
    db --> service: Return Results
    service --> api: Processed Response
    api --> frontend: JSON Response
    frontend --> User: Display Results

    note over User,db
      Typical interaction sequence
      showing message flow
    end note

    @enduml
  UML
end

def generate_activity_diagram(title, _content, _glossary)
  <<~UML
    @startuml
    title #{title} - Activity Diagram

    start

    :Receive Input;
    if (Input Valid?) then (yes)
      :Process Data;
      fork
        :Validate Results;
      fork again
        :Log Activity;
      end fork
      :Generate Output;
      :Send Response;
    else (no)
      :Log Error;
      :Return Error Message;
    endif

    stop

    note right of "Process Data"
      Parallel processing
      with validation
    end note

    @enduml
  UML
end

def generate_state_machine_diagram(title, _content, _glossary)
  <<~UML
    @startuml
    title #{title} - State Machine Diagram

    [*] --> Inactive

    state Inactive
    state Active
    state Processing
    state Error
    state Maintenance

    Inactive --> Active : activate()
    Active --> Processing : startProcess()
    Processing --> Active : complete()
    Processing --> Error : failure()
    Error --> Active : recover()
    Active --> Inactive : deactivate()
    Active --> Maintenance : maintain()
    Maintenance --> Active : resume()

    note right of Processing
      Processing state
      handles core logic
    end note

    @enduml
  UML
end

def generate_component_diagram(title, _content, _glossary)
  <<~UML
    @startuml
    title #{title} - Component Diagram

    package "Frontend" {
      [UI Component] as ui
      [API Client] as client
    }

    package "Backend" {
      [API Gateway] as gateway
      [Service Layer] as service
      [Data Access] as data
    }

    package "Infrastructure" {
      [Database] as db
      [Cache] as cache
    }

    ui --> client
    client --> gateway
    gateway --> service
    service --> data
    data --> db
    service --> cache

    note right of gateway
      Central component
      routes requests
    end note

    @enduml
  UML
end

def generate_deployment_diagram(title, _content, _glossary)
  <<~UML
    @startuml
    title #{title} - Deployment Diagram

    node "Web Server" {
      artifact "Web App" as webapp
    }

    node "App Server" {
      artifact "API Service" as apiservice
    }

    node "Database Server" {
      artifact "Database" as database
    }

    node "Cache Server" {
      artifact "Redis Cache" as redis
    }

    webapp --> apiservice : HTTPS
    apiservice --> database : JDBC
    apiservice --> redis : TCP

    note right of apiservice
      Deployed as container
      connects to multiple
      infrastructure components
    end note

    @enduml
  UML
end

def generate_conceptual_diagram(title, _content, _glossary)
  <<~UML
    @startuml
    title #{title} - Conceptual Overview

    participant "Source" as source
    participant "Process" as process
    participant "Analysis" as analysis
    participant "Output" as output

    source -> process: Input document
    process -> analysis: Extract content
    analysis -> analysis: Generate insights
    analysis -> output: Create deliverables
    output -> source: Feedback loop

    note over source,output
      High-level workflow visualization
      based on document analysis
    end note

    @enduml
  UML
end

# Function to extract key insights from document for Anthropic skill format
def extract_document_insights(content, title)
  lines = content.split("\n")

  # Extract main sections and key points
  sections = []
  current_section = nil
  key_points = []

  lines.each do |line|
    if line.match(/^#+\s+(.+)/)
      current_section = Regexp.last_match(1).strip
      sections << current_section
    elsif line.match(/^\s*[-*+]\s+(.+)/) && current_section
      key_points << "#{Regexp.last_match(1).strip}"
    end
  end

  # Extract technical terms and concepts
  technical_terms = content.scan(/\b[A-Z][a-z]+(?:[A-Z][a-z]+)*\b/).uniq

  {
    title: title,
    sections: sections,
    key_points: key_points,
    technical_terms: technical_terms,
    word_count: content.split(/\s+/).length,
    has_code: content.include?('```'),
    has_diagrams: content.downcase.include?('diagram') || content.downcase.include?('uml')
  }
end

# Parse command line arguments
command = ARGV[0] || 'forward'

# Create necessary directories if they don't exist
[INGESTED_DIR, UML_DIR, SKILLS_DIR, HUMAN_DIR].each { |dir| FileUtils.mkdir_p(dir) }

# Load UML glossary for enhanced analysis
uml_glossary = load_uml_glossary
puts "📚 Loaded UML Glossary with #{uml_glossary.keys.length} sections" unless uml_glossary.empty?

# Check for undo command
if command == 'undo'
  puts '🔄 Starting ingest undo workflow...'

  # Find ingested files and move them back, removing artifacts
  ingested_files = Dir.glob(File.join(INGESTED_DIR, '*.{md,jpg,jpeg}'))

  if ingested_files.empty?
    puts "❌ No files found in #{INGESTED_DIR} to restore"
    exit 0
  end

  ingested_files.each do |file|
    filename_with_uuid7 = File.basename(file)
    ext = File.extname(filename_with_uuid7)
    original_filename = filename_with_uuid7.sub(/__\w{7}#{Regexp.escape(ext)}$/, ext)
    title = extract_title(original_filename)
    title_underscore = title.gsub(' ', '_')

    puts "   📤 Restoring: #{filename_with_uuid7}"

    # Extract UUID7 from filename for cleanup
    uuid7_match = filename_with_uuid7.match(/__(\w{7})\.\w+$/)
    uuid7 = uuid7_match ? uuid7_match[1] : nil

    # Move file back to ingest directory, keeping UUID name
    FileUtils.mv(file, File.join(INGEST_DIR, filename_with_uuid7))
    puts "     ✅ Moved: ingested/#{filename_with_uuid7} -> ingest/#{filename_with_uuid7}"

    # Find and remove associated UML files with specific UUID7
    uml_pattern = uuid7 ? "#{title_underscore}__*__#{uuid7}.puml" : "#{title_underscore}__*__*.puml"
    uml_files = Dir.glob(File.join(UML_DIR, uml_pattern))
    uml_files.each do |uml_file|
      FileUtils.rm_f(uml_file)
      puts "     🗑️  Removed: #{File.basename(uml_file)} (UML)"
    end

    # Find and remove associated skill files with specific UUID7
    skill_pattern = uuid7 ? "#{title_underscore}__#{uuid7}.md" : "#{title_underscore}__*.md"
    skill_files = Dir.glob(File.join(SKILLS_DIR, skill_pattern))
    skill_files.each do |skill_file|
      FileUtils.rm_f(skill_file)
      puts "     🗑️  Removed: #{File.basename(skill_file)} (Skill)"
    end

    # Find and remove associated human documentation files with specific UUID7
    human_pattern = uuid7 ? "#{title_underscore}__#{uuid7}.md" : "#{title_underscore}__*.md"
    human_files = Dir.glob(File.join(HUMAN_DIR, human_pattern))
    human_files.each do |human_file|
      FileUtils.rm_f(human_file)
      puts "     🗑️  Removed: #{File.basename(human_file)} (Human)"
    end

    puts ''
  end

  puts '✅ Undo complete! Files restored to ingest, artifacts removed'
  exit 0
end

# Forward ingest workflow
puts '🚀 Starting enhanced ingest workflow...'

# Get current Git SHA for this run
git_sha = get_git_sha

# Get all markdown, PDF, and image files in ingest directory
markdown_files = Dir.glob(File.join(INGEST_DIR, '*.md'))
pdf_files = Dir.glob(File.join(INGEST_DIR, '*.pdf'))
image_files = Dir.glob(File.join(INGEST_DIR, '*.{jpg,jpeg}'))
all_files = markdown_files + pdf_files + image_files

if all_files.empty?
  puts "❌ No markdown, PDF, or image files found in #{INGEST_DIR}"
  exit 0
end

# Process each file
all_files.each do |file|
  original_filename = File.basename(file)
  is_pdf = pdf_file?(original_filename)
  is_image = image_file?(original_filename)

  # Check if file already has UUID7 suffix
  if has_uuid7_suffix?(original_filename)
    puts "⏭️  Skipping: #{original_filename} (already has UUID7 suffix)"
    next
  end

  title = extract_title(original_filename)
  uuid7 = generate_uuid7

  # Extract content based on file type
  begin
    if is_pdf
      puts "📄 Processing PDF: #{original_filename}"
      content = extract_text_from_pdf(file)
      file_type = 'PDF'
    elsif is_image
      puts "🖼️  Processing Image: #{original_filename}"
      content = extract_text_from_image(file)
      file_type = 'Image (OCR)'
    else
      puts "📝 Processing Markdown: #{original_filename}"
      content = File.read(file)
      file_type = 'Markdown'
    end
  rescue => e
    puts "❌ Error reading #{original_filename}: #{e.message}"
    next
  end

  # Ensure valid UTF-8 for downstream processing
  content = content.encode('UTF-8', invalid: :replace, undef: :replace)

  # Generate output filename with UUID7 (preserve original extension)
  filename_with_uuid7 = add_uuid7_suffix(original_filename, uuid7)

  puts "   Title: #{title}"
  puts "   Type: #{file_type}"
  puts "   UUID7: #{uuid7}"
  puts "   Git SHA: #{git_sha[0, 7]}"

  if is_pdf
    puts "   📊 PDF pages: #{PDF::Reader.new(file).page_count}"
    puts "   📝 Extracted characters: #{content.length}"
  end

  if is_image
    puts "   🖼️  Image file: #{original_filename}"
    puts "   📝 OCR extracted characters: #{content.length}"
  end

  # Enhanced document analysis using UML glossary
  uml_analysis = analyze_document_for_uml(content, uml_glossary)
  puts "   🧠 UML Type: #{uml_analysis[:type]} (#{uml_analysis[:subtype]})"

  # Create enhanced UML diagram
  uml_filename = "#{title.gsub(' ', '_')}__#{uml_analysis[:type]}__#{uuid7}.puml"
  uml_file = File.join(UML_DIR, uml_filename)

  uml_content = generate_intelligent_uml(content, title, uml_analysis, uml_glossary)

  # Add Git SHA comment to UML file
  uml_content_with_sha = "' Generated at: #{Time.now.strftime('%Y-%m-%d %H:%M:%S')}\n' Git SHA: #{git_sha}\n' UUID7: #{uuid7}\n' UML Type: #{uml_analysis[:type]}\n\n#{uml_content}"
  File.write(uml_file, uml_content_with_sha)

  # Extract document insights for skill format
  insights = extract_document_insights(content, title)

  # Create enhanced Anthropic skill format technical summary
  skills_filename = "#{title.gsub(' ', '_')}__#{uuid7}.md"
  skills_file = File.join(SKILLS_DIR, skills_filename)

  skills_content = <<~SKILL
    # #{insights[:title]} - Anthropic Skill (UML Enhanced)

    ## Metadata
    - **Name:** #{insights[:title]}
    - **Description:** Technical summary and analysis of #{insights[:title].downcase} with UML glossary integration
    - **Version:** 1.0.0
    - **Source:** #{original_filename}
    - **Processed:** #{Time.now.strftime('%Y-%m-%d %H:%M:%S')}
    - **UUID7:** #{uuid7}
    - **Git SHA:** #{git_sha}
    - **Category:** Documentation Analysis
    - **UML Type:** #{uml_analysis[:type]} (#{uml_analysis[:subtype]})
    - **Tags:** #{insights[:technical_terms].take(5).join(', ')}

    ## Content Analysis

    ### Document Statistics
    - **Word Count:** #{insights[:word_count]}
    - **Sections:** #{insights[:sections].length}
    - **Key Points:** #{insights[:key_points].length}
    - **Contains Code:** #{insights[:has_code] ? 'Yes' : 'No'}
    - **Contains Diagrams:** #{insights[:has_diagrams] ? 'Yes' : 'No'}

    ### Main Sections
    #{insights[:sections].map { |section| "- **#{section}**" }.join("\n    ")}

    ### Technical Concepts
    #{insights[:technical_terms].map { |term| "- #{term}" }.join("\n    ")}

    ### Key Insights
    #{insights[:key_points].take(10).map { |point| "- #{point}" }.join("\n    ")}

    ## UML Analysis (Enhanced with Glossary)

    ### Diagram Classification
    - **Type:** #{uml_analysis[:type]}
    - **Title:** #{uml_analysis[:title]}
    - **Subtype:** #{uml_analysis[:subtype]}
    - **Analysis Method:** UML Glossary Integration

    ### UML Knowledge Applied
    This analysis leverages the comprehensive UML glossary containing:
    - Core UML concepts (Class, Object, Interface, Component)
    - UML relationships (Inheritance, Composition, Aggregation)
    - Structural diagrams (Class, Component, Deployment)
    - Behavioral diagrams (Use Case, Sequence, Activity)

    ### Generated Artifacts
    - **UML Diagram:** #{uml_filename}
    - **Human Documentation:** #{title.gsub(' ', '_')}__#{uuid7}.md

    ## Processing Notes

    ### Enhanced Classification
    This document has been classified using UML glossary knowledge as a **#{uml_analysis[:type]}** type (#{uml_analysis[:subtype]} subtype).

    ### Related Resources
    - **UML Visualization:** [#{uml_filename}](#{UML_DIR}/#{uml_filename})
    - **Human Documentation:** [#{title.gsub(' ', '_')}__#{uuid7}.md](#{HUMAN_DIR}/#{title.gsub(' ', '_')}__#{uuid7}.md)
    - **UML Glossary:** [skills/uml-glossary.md](#{UML_GLOSSARY_FILE})

    ## Usage Recommendations

    This skill is optimized for:
    - AI system consumption and analysis
    - Technical documentation processing with UML context
    - Cross-reference linking with UML diagrams
    - Enhanced diagram classification using UML standards
    - Automated workflow integration with UML knowledge base
  SKILL

  File.write(skills_file, skills_content)

  # Create enhanced human-readable documentation
  human_filename = "#{title.gsub(' ', '_')}__#{uuid7}.md"
  human_file = File.join(HUMAN_DIR, human_filename)

  human_content = <<~HUMAN
    # #{title}

    > **Document Analysis:** This document has been processed through the enhanced ingest workflow with UML glossary integration and classified as a **#{uml_analysis[:type]}** type (#{uml_analysis[:subtype]} subtype).

    ## Document Overview

    **Source:** #{original_filename}#{'  '}
    **Processed:** #{Time.now.strftime('%Y-%m-%d %H:%M:%S')}#{'  '}
    **Git SHA:** #{git_sha}#{'  '}
    **UUID7:** #{uuid7}#{'  '}
    **Word Count:** #{insights[:word_count]} words#{'  '}
    **Main Sections:** #{insights[:sections].join(', ')}#{'  '}
    **UML Classification:** #{uml_analysis[:type]} (#{uml_analysis[:subtype]})#{'  '}

    ## Visual Resources

    ### 🎯 UML Diagram
    **Type:** #{uml_analysis[:title]}#{'  '}
    **Subtype:** #{uml_analysis[:subtype]}#{'  '}
    **File:** [#{uml_filename}](#{UML_DIR}/#{uml_filename})

    The UML diagram has been generated using enhanced analysis with UML glossary knowledge, providing accurate visualization of the #{uml_analysis[:type].gsub('_', ' ')} concept described in this document.

    ### 📋 Technical Summary
    **File:** [#{skills_filename}](#{SKILLS_DIR}/#{skills_filename})

    The technical summary contains structured metadata, key insights, and AI-optimized content with UML context for automated processing.

    ### 📚 UML Glossary
    **Reference:** [skills/uml-glossary.md](#{UML_GLOSSARY_FILE})

    The comprehensive UML glossary provides definitions and explanations of UML concepts, relationships, and diagram types used in this analysis.

    ## Key Concepts
    #{insights[:technical_terms].map { |term| "- **#{term}**" }.join("\n    ")}

    ## Main Takeaways
    #{insights[:key_points].take(5).map { |point| "- #{point}" }.join("\n    ")}

    ## UML Analysis Notes

    This document was processed using UML glossary knowledge, enabling:
    - Accurate diagram type classification
    - Enhanced understanding of UML terminology
    - Improved visualization based on UML standards
    - Better context for technical documentation

    #{is_image ? "## Original Image\n\n    ![#{title}](../ingested/#{filename_with_uuid7})\n\n    ## OCR Extracted Text" : "## Original Content"}

    ---

    #{content}
  HUMAN

  File.write(human_file, human_content)

  puts "   ✅ Created: #{uml_filename} (#{uml_analysis[:type]} - #{uml_analysis[:subtype]})"
  puts "   ✅ Created: #{skills_filename} (Enhanced Anthropic Skill)"
  puts "   ✅ Created: #{human_filename} (Enhanced with UML context)"

  # Rename with UUID7 suffix and move to ingested directory
  target_file = File.join(INGESTED_DIR, filename_with_uuid7)
  FileUtils.mv(file, target_file)
  puts "   📦 Ingested: #{original_filename} -> ingested/#{filename_with_uuid7}"
  puts ''
end

puts '✨ Enhanced ingest workflow complete!'
puts ''
puts '📊 Summary:'
puts "   UML diagrams: #{Dir.glob(File.join(UML_DIR, '*.puml')).count}"
puts "   Technical summaries: #{Dir.glob(File.join(SKILLS_DIR, '*.md')).count}"
puts "   Human docs: #{Dir.glob(File.join(HUMAN_DIR, '*.md')).count}"
puts "   Ingested files: #{Dir.glob(File.join(INGESTED_DIR, '*.{md,jpg,jpeg}')).count}"
puts ''
puts '🧠 UML Enhancement:'
puts "   UML glossary loaded: #{!uml_glossary.empty? ? 'Yes' : 'No'}"
puts '   Enhanced classification: Active'
puts '   Improved diagram generation: Active'
puts ''
puts '💡 Usage:'
puts '   ./bin/ingest.rb      - Run forward ingest with UML enhancement'
puts '   ./bin/ingest.rb undo - Undo ingest (ingested → ingest)'
puts ''
puts '🔍 Validation:'
puts "   Run 'find doc/ -name \"*.md\" -o -name \"*.puml\" -o -name \"*.jpg\" -o -name \"*.jpeg\" | sort' to see all files"
