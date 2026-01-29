# Ingest Workflow Skill

## Metadata
- **Name:** Ingest Workflow
- **Description:** Transforms source documentation into standardized formats (UML diagrams, technical summaries, human-readable docs) with proper cross-references
- **Version:** 1.0.0
- **Author:** OpenCode Workflow
- **Category:** Documentation Processing
- **Tags:** documentation, workflow, automation, uml, markdown
- **Created:** 2026-01-29
- **Updated:** 2026-01-29

## Overview

The ingest workflow automates the transformation of source documentation into multiple standardized formats for different audiences. This process converts raw documentation into UML diagrams, technical summaries, and human-readable documentation with proper cross-references.

## Prerequisites

### Required Knowledge
- Basic familiarity with Markdown and PlantUML
- UUID generation concepts (time-based identifiers)
- File system navigation and text editing

### Required Tools
- Ruby runtime (for ingest.rb script)
- Text editor for file modifications
- Command line interface

### Directory Structure
```
magentic-switch/
├── bin/
│   └── ingest.rb                 # Main ingest script
├── doc/
│   ├── ingest/                   # Source documents (input)
│   │   └── *.md                  # Raw documentation files
│   ├── ingested/                 # Processed source documents (archive)
│   │   └── *.md                  # Archived original files
│   ├── uml/                      # UML diagrams (output)
│   │   └── *.puml                # PlantUML diagram files
│   ├── skills/                   # Technical summaries (output)
│   │   └── *.md                  # AI/system-friendly summaries
│   └── human/                    # Human-readable docs (output)
│       └── *.md                  # Documentation with cross-references
└── skill/                        # Additional skill files
```

## Core Functions

### `execute_ingest()`
**Purpose:** Process all markdown files in doc/ingest/ directory

**Input:** 
- Markdown files in doc/ingest/ directory

**Output:**
- UML diagrams in doc/uml/
- Technical summaries in doc/skills/
- Human-readable documentation in doc/human/
- Original files archived to doc/ingested/

**Process:**
1. Scan doc/ingest/ for *.md files
2. Generate unique UUID7 identifier for each file
3. Extract title from filename
4. **Intelligent Analysis**: Analyze document content to determine optimal UML diagram type
5. **Smart UML Generation**: Create context-aware UML diagram based on document classification
6. **Anthropic Skill Format**: Generate technical summary following Anthropic skill standards
7. **Enhanced Documentation**: Create human-readable docs with analysis insights
8. Archive original file to doc/ingested/

### `execute_undo()`
**Purpose:** Reverse the ingest process

**Input:**
- Files in doc/ingested/ directory

**Output:**
- Files moved back to doc/ingest/ directory

**Process:**
1. Scan doc/ingested/ for *.md files
2. Move files back to doc/ingest/
3. Preserve generated outputs in other directories

## Usage Instructions

### Command Line Interface

#### Run Forward Ingest
```bash
./bin/ingest.rb
```
- Processes all files in doc/ingest/
- Creates standardized outputs
- Archives original files

#### Run Undo
```bash
./bin/ingest.rb undo
```
- Restores files from doc/ingested/ to doc/ingest/
- Does not remove generated outputs

### File Naming Conventions

#### UUID7 Generation
- Format: 7-character time-based hash
- Example: `a1b2c3d`
- Purpose: Ensures uniqueness across documents

#### Output Files
- **UML Diagrams:** `TITLE__diagram_type__UUID7.puml`
- **Technical Summaries:** `TITLE__UUID7.md`
- **Human Documentation:** `TITLE__UUID7.md`

## Templates

### Intelligent UML Generation

The system analyzes document content to determine the optimal UML diagram type:

#### Supported Diagram Types
- **User Journey** (`user_journey`) - For user persona and interaction documents
- **Process Flow** (`workflow`) - For workflow and process descriptions
- **System Context** (`system_context`) - For architecture and system overviews
- **Agent Interaction** (`agent_interaction`) - For AI agent and multi-agent systems
- **API Sequence** (`api_sequence`) - For API documentation and interfaces
- **Conflict Resolution** (`conflict_resolution`) - For merge conflict and resolution processes
- **Comparison Analysis** (`comparison`) - For comparative studies and alternatives
- **Conceptual Overview** (`conceptual`) - Default for general documentation

#### Classification Algorithm
The system uses keyword-based content analysis to classify documents and generate appropriate UML diagrams with meaningful actors, participants, and interactions specific to the document type.

### Anthropic Skill Format Template
```markdown
# [TITLE] - Anthropic Skill

## Metadata
- **Name:** [Document Title]
- **Description:** Technical summary and analysis
- **Version:** 1.0.0
- **Source:** [filename]
- **Processed:** [timestamp]
- **UUID7:** [identifier]
- **Category:** Documentation Analysis
- **Tags:** [extracted technical terms]

## Content Analysis

### Document Statistics
- **Word Count:** [number]
- **Sections:** [count]
- **Key Points:** [count]
- **Contains Code:** [Yes/No]
- **Contains Diagrams:** [Yes/No]

### Main Sections
- **Section 1**
- **Section 2**
- ...

### Technical Concepts
- **Concept 1**
- **Concept 2**
- ...

### Key Insights
- **Insight 1**
- **Insight 2**
- ...

## UML Analysis
### Diagram Type
- **Type:** [classified type]
- **Title:** [diagram title]

### Generated Artifacts
- **UML Diagram:** [filename.puml]
- **Human Documentation:** [filename.md]

## Processing Notes
### Document Classification
This document has been classified based on content analysis.

### Related Resources
- **UML Visualization:** [link to UML file]
- **Human Documentation:** [link to human file]

## Usage Recommendations
This skill is optimized for AI system consumption and technical documentation processing.
```

### Human Documentation Template
```markdown
# [TITLE]

This document provides an overview of [TITLE].

## Resources
- **Workflow Diagram**: [link to UML file]
- **Technical Summary**: [link to skills file]

## Document Content
[original content]
```

## Validation Procedures

### Pre-Execution Validation
- [ ] doc/ingest/ directory exists
- [ ] Markdown files present in doc/ingest/
- [ ] Required directories created
- [ ] ingest.rb script is executable

### Post-Execution Validation
```bash
# Check all generated files exist
find doc/ -name "*.md" -o -name "*.puml" | sort

# Verify directory structure
tree doc/ -I __pycache__

# Test cross-references (if using markdown preview)
# Navigate to doc/human/ and verify links work
```

### File Counts Validation
- UML diagrams: Count *.puml files in doc/uml/
- Technical summaries: Count *.md files in doc/skills/
- Human docs: Count *.md files in doc/human/
- Archived files: Count *.md files in doc/ingested/

## Error Handling

### Common Issues
- **Empty ingest directory:** No markdown files found
- **Permission errors:** Unable to create/move files
- **Missing directories:** Required directories don't exist
- **Naming conflicts:** Duplicate UUID7 identifiers

### Resolution Strategies
- Verify input files exist and are readable
- Check directory permissions
- Run mkdir commands to create missing directories
- Regenerate UUID7 if collisions occur

## Integration Points

### Version Control
- Commit generated files to track documentation evolution
- Archive original files to maintain history
- Use consistent naming for easy tracking

### Documentation Systems
- UML diagrams can be rendered by PlantUML tools
- Technical summaries optimized for AI consumption
- Human documentation includes proper cross-references

## Performance Considerations

### Scalability
- Processes files individually to handle large datasets
- Uses efficient file operations
- Maintains clean separation of concerns

### Resource Usage
- Minimal memory footprint
- No external dependencies beyond Ruby standard library
- Fast execution for typical documentation volumes

## Troubleshooting Commands

```bash
# Fix broken permissions
chmod 644 doc/*/*.md doc/*/*.puml

# Check for missing files
diff <(ls doc/ingest/) <(ls doc/ingested/)

# Verify UUID consistency
grep -r "UUID7_IDENTIFIER" doc/

# Validate PlantUML syntax
plantuml doc/uml/*.puml
```

## Future Enhancements

### Potential Automations
- Automatic UUID generation optimization
- PlantUML diagram generation from content analysis
- Cross-reference link validation
- Batch processing with progress indicators

### Extended Features
- Support for additional output formats
- Custom template system
- Integration with external documentation tools
- Automated quality checks