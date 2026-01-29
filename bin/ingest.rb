#!/usr/bin/env ruby

# Ingest Workflow Script
# Automates the transformation of source documentation into multiple standardized formats
# Usage: ./bin/ingest.rb [undo]

require 'fileutils'
require 'digest'
require 'time'

# Directory setup
INGEST_DIR = 'doc/ingest'
INGESTED_DIR = 'doc/ingested'
UML_DIR = 'doc/uml'
SKILLS_DIR = 'doc/skills'
HUMAN_DIR = 'doc/human'

# Function to generate UUID7
def generate_uuid7
  Digest::MD5.hexdigest((Time.now.to_f * 1000).to_i.to_s)[0, 7]
end

# Function to extract title from filename
def extract_title(filename)
  # Remove .md extension and convert underscores to spaces, capitalize words
  filename.sub(/\.md$/, '').gsub('_', ' ').split.map(&:capitalize).join(' ')
end

# Function to analyze document content and determine UML diagram type
def analyze_document_for_uml(content)
  content_lower = content.downcase

  # Determine document type based on content analysis
  if content_lower.include?('user') && content_lower.include?('persona')
    { type: 'user_journey', title: 'User Journey' }
  elsif content_lower.include?('workflow') || content_lower.include?('process')
    { type: 'workflow', title: 'Process Flow' }
  elsif content_lower.include?('system') && content_lower.include?('architecture')
    { type: 'system_context', title: 'System Context' }
  elsif content_lower.include?('agent') || content_lower.include?('ai')
    { type: 'agent_interaction', title: 'Agent Interaction' }
  elsif content_lower.include?('api') && (content_lower.include?('endpoint') || content_lower.include?('interface'))
    { type: 'api_sequence', title: 'API Sequence' }
  elsif content_lower.include?('merge') && content_lower.include?('conflict')
    { type: 'conflict_resolution', title: 'Conflict Resolution' }
  elsif content_lower.include?('comparison') || content_lower.include?('versus')
    { type: 'comparison', title: 'Comparison Analysis' }
  else
    { type: 'conceptual', title: 'Conceptual Overview' }
  end
end

# Function to generate intelligent UML diagram based on document analysis
def generate_intelligent_uml(_content, title, analysis)
  case analysis[:type]
  when 'user_journey'
    <<~UML
      @startuml
      title #{title} - User Journey

      actor User as user
      participant "OpenCode" as system
      database "GitHub" as github

      user -> system: Initialize request
      system -> user: Present analysis plan
      user -> system: Approve plan
      system -> github: Fetch repository data
      system -> system: Analyze codebase
      system -> user: Show proposed changes
      user -> system: Apply modifications
      system -> github: Create pull request
      github -> user: Notification of PR
      user -> github: Review and merge

      @enduml
    UML

  when 'workflow'
    <<~UML
      @startuml
      title #{title} - Workflow Process

      participant "Input" as input
      participant "Process" as process
      participant "Validation" as validate
      participant "Output" as output

      input -> process: Submit document
      process -> validate: Check quality
      validate --> process: Valid document
      process -> output: Generate artifacts
      output -> process: Confirm completion

      @enduml
    UML

  when 'system_context'
    <<~UML
      @startuml
      title #{title} - System Context

      package "External Systems" {
        [User Interface] as ui
        [API Gateway] as api
        [Database] as db
      }

      package "Core System" {
        [Processing Engine] as engine
        [Analysis Module] as analysis
        [Output Generator] as output
      }

      ui --> api
      api --> engine
      engine --> analysis
      analysis --> output
      engine --> db

      @enduml
    UML

  when 'agent_interaction'
    <<~UML
      @startuml
      title #{title} - Agent Interaction

      participant "User" as user
      participant "Primary Agent" as primary
      participant "Sub-agent" as subagent
      participant "Tools" as tools

      user -> primary: Initiate task
      primary -> primary: Analyze requirements
      primary -> subagent: Delegate subtask
      subagent -> tools: Execute operations
      tools --> subagent: Return results
      subagent --> primary: Report completion
      primary -> user: Present final output

      @enduml
    UML

  when 'api_sequence'
    <<~UML
      @startuml
      title #{title} - API Sequence

      participant "Client" as client
      participant "API Gateway" as gateway
      participant "Service" as service
      database "Database" as db

      client -> gateway: HTTP Request
      gateway -> service: Forward request
      service -> db: Query data
      db --> service: Return data
      service --> gateway: Processed response
      gateway --> client: HTTP Response

      @enduml
    UML

  when 'conflict_resolution'
    <<~UML
      @startuml
      title #{title} - Conflict Resolution

      participant "Developer A" as dev_a
      participant "Developer B" as dev_b
      participant "Version Control" as vcs
      participant "Resolution" as resolve

      dev_a -> vcs: Push changes
      dev_b -> vcs: Push conflicting changes
      vcs -> dev_b: Conflict detected
      dev_b -> resolve: Analyze conflicts
      resolve -> dev_a: Request review
      dev_a --> resolve: Provide feedback
      resolve -> vcs: Merged solution
      vcs -> dev_b: Success confirmation

      @enduml
    UML

  when 'comparison'
    <<~UML
      @startuml
      title #{title} - Comparison Analysis

      participant "Option A" as option_a
      participant "Analysis" as analysis
      participant "Option B" as option_b
      participant "Result" as result

      option_a -> analysis: Submit criteria
      option_b -> analysis: Submit criteria
      analysis -> analysis: Compare features
      analysis -> analysis: Evaluate trade-offs
      analysis -> result: Generate recommendation
      result -> option_a: Feedback for A
      result -> option_b: Feedback for B

      @enduml
    UML

  else # conceptual
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

      @enduml
    UML
  end
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

# Check for undo command
if command == 'undo'
  puts '🔄 Starting ingest undo workflow...'

  # Move all files back from ingested to ingest
  ingested_files = Dir.glob(File.join(INGESTED_DIR, '*.md'))

  if ingested_files.empty?
    puts "❌ No files found in #{INGESTED_DIR} to restore"
    exit 0
  end

  ingested_files.each do |file|
    filename = File.basename(file)
    title = extract_title(filename)
    title_underscore = title.gsub(' ', '_')

    puts "   📤 Restoring: #{filename}"

    # Move original file back to ingest directory
    FileUtils.mv(file, File.join(INGEST_DIR, filename))
    puts "     ✅ Moved: #{filename} -> doc/ingest/"

    # Find and remove associated UML files
    uml_files = Dir.glob(File.join(UML_DIR, "#{title_underscore}__*__*.puml"))
    uml_files.each do |uml_file|
      FileUtils.rm_f(uml_file)
      puts "     🗑️  Removed: #{File.basename(uml_file)} (UML)"
    end

    # Find and remove associated skill files
    skill_files = Dir.glob(File.join(SKILLS_DIR, "#{title_underscore}__*.md"))
    skill_files.each do |skill_file|
      FileUtils.rm_f(skill_file)
      puts "     🗑️  Removed: #{File.basename(skill_file)} (Skill)"
    end

    # Find and remove associated human documentation files
    human_files = Dir.glob(File.join(HUMAN_DIR, "#{title_underscore}__*.md"))
    human_files.each do |human_file|
      FileUtils.rm_f(human_file)
      puts "     🗑️  Removed: #{File.basename(human_file)} (Human)"
    end

    puts ''
  end

  puts '✅ Undo complete! All files and associated artifacts cleaned up'
  exit 0
end

# Forward ingest workflow
puts '🚀 Starting ingest workflow...'

# Get all markdown files in ingest directory
markdown_files = Dir.glob(File.join(INGEST_DIR, '*.md'))

if markdown_files.empty?
  puts "❌ No markdown files found in #{INGEST_DIR}"
  exit 0
end

# Process each markdown file
markdown_files.each do |file|
  filename = File.basename(file)
  title = extract_title(filename)
  uuid7 = generate_uuid7
  content = File.read(file)

  puts "📄 Processing: #{filename}"
  puts "   Title: #{title}"
  puts "   UUID7: #{uuid7}"

  # Analyze document for intelligent UML generation
  uml_analysis = analyze_document_for_uml(content)
  puts "   🧠 UML Type: #{uml_analysis[:type]}"

  # Create intelligent UML diagram
  uml_filename = "#{title.gsub(' ', '_')}__#{uml_analysis[:type]}__#{uuid7}.puml"
  uml_file = File.join(UML_DIR, uml_filename)

  uml_content = generate_intelligent_uml(content, title, uml_analysis)
  File.write(uml_file, uml_content)

  # Extract document insights for skill format
  insights = extract_document_insights(content, title)

  # Create Anthropic skill format technical summary
  skills_filename = "#{title.gsub(' ', '_')}__#{uuid7}.md"
  skills_file = File.join(SKILLS_DIR, skills_filename)

  skills_content = <<~SKILL
    # #{insights[:title]} - Anthropic Skill

    ## Metadata
    - **Name:** #{insights[:title]}
    - **Description:** Technical summary and analysis of #{insights[:title].downcase}
    - **Version:** 1.0.0
    - **Source:** #{filename}
    - **Processed:** #{Time.now.strftime('%Y-%m-%d %H:%M:%S')}
    - **UUID7:** #{uuid7}
    - **Category:** Documentation Analysis
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

    ## UML Analysis

    ### Diagram Type
    - **Type:** #{uml_analysis[:type]}
    - **Title:** #{uml_analysis[:title]}

    ### Generated Artifacts
    - **UML Diagram:** #{uml_filename}
    - **Human Documentation:** #{title.gsub(' ', '_')}__#{uuid7}.md

    ## Processing Notes

    ### Document Classification
    This document has been classified as a **#{uml_analysis[:type]}** type based on content analysis.

    ### Related Resources
    - **UML Visualization:** [#{uml_filename}](#{UML_DIR}/#{uml_filename})
    - **Human Documentation:** [#{title.gsub(' ', '_')}__#{uuid7}.md](#{HUMAN_DIR}/#{title.gsub(' ', '_')}__#{uuid7}.md)

    ## Usage Recommendations

    This skill is optimized for:
    - AI system consumption and analysis
    - Technical documentation processing
    - Cross-reference linking with UML diagrams
    - Automated workflow integration
  SKILL

  File.write(skills_file, skills_content)

  # Create enhanced human-readable documentation
  human_filename = "#{title.gsub(' ', '_')}__#{uuid7}.md"
  human_file = File.join(HUMAN_DIR, human_filename)

  human_content = <<~HUMAN
    # #{title}

    > **Document Analysis:** This document has been processed through the intelligent ingest workflow and classified as a **#{uml_analysis[:type]}** type.

    ## Document Overview

    **Source:** #{filename}#{'  '}
    **Processed:** #{Time.now.strftime('%Y-%m-%d %H:%M:%S')}#{'  '}
    **Word Count:** #{insights[:word_count]} words#{'  '}
    **Main Sections:** #{insights[:sections].join(', ')}#{'  '}

    ## Visual Resources

    ### 🎯 UML Diagram
    **Type:** #{uml_analysis[:title]}#{'  '}
    **File:** [#{uml_filename}](#{UML_DIR}/#{uml_filename})

    The UML diagram visualizes the #{uml_analysis[:type].gsub('_', ' ')} flow described in this document, providing a clear visual representation of the concepts and interactions.

    ### 📋 Technical Summary
    **File:** [#{skills_filename}](#{SKILLS_DIR}/#{skills_filename})

    The technical summary contains structured metadata, key insights, and AI-optimized content for automated processing.

    ## Key Concepts
    #{insights[:technical_terms].map { |term| "- **#{term}**" }.join("\n    ")}

    ## Main Takeaways
    #{insights[:key_points].take(5).map { |point| "- #{point}" }.join("\n    ")}

    ## Original Content

    ---

    #{content}
  HUMAN

  File.write(human_file, human_content)

  puts "   ✅ Created: #{uml_filename} (#{uml_analysis[:type]})"
  puts "   ✅ Created: #{skills_filename} (Anthropic Skill)"
  puts "   ✅ Created: #{human_filename} (Enhanced)"

  # Move original file to ingested directory
  FileUtils.mv(file, File.join(INGESTED_DIR, filename))
  puts "   📦 Archived: #{filename} -> doc/ingested/"
  puts ''
end

puts '✨ Ingest workflow complete!'
puts ''
puts '📊 Summary:'
puts "   UML diagrams: #{Dir.glob(File.join(UML_DIR, '*.puml')).count}"
puts "   Technical summaries: #{Dir.glob(File.join(SKILLS_DIR, '*.md')).count}"
puts "   Human docs: #{Dir.glob(File.join(HUMAN_DIR, '*.md')).count}"
puts "   Archived files: #{Dir.glob(File.join(INGESTED_DIR, '*.md')).count}"
puts ''
puts '💡 Usage:'
puts '   ./bin/ingest.rb      - Run forward ingest (ingest → ingested)'
puts '   ./bin/ingest.rb undo - Undo ingest (ingested → ingest)'
puts ''
puts '🔍 Validation:'
puts "   Run 'find doc/ -name \"*.md\" -o -name \"*.puml\" | sort' to see all files"
