# Antipatterns

> **Document Analysis:** This document has been processed through the enhanced ingest workflow with UML glossary integration and classified as a **conceptual** type (general subtype).

## Document Overview

**Source:** ANTIPATTERNS.md  
**Processed:** 2026-01-29 17:31:41  
**Git SHA:** 7a6f8947bd62d2dae362b154bb934689fdf0f30c  
**UUID7:** 58b73f2  
**Word Count:** 131 words  
**Main Sections:** MCP-UI Anti‑Patterns, AP‑001 — Model‑First Design, AP‑002 — Enumerated Artifact Types, AP‑003 — Executable Semantics  
**UML Classification:** conceptual (general)  

## Visual Resources

### 🎯 UML Diagram
**Type:** Conceptual Overview  
**Subtype:** general  
**File:** [Antipatterns__conceptual__58b73f2.puml](doc/uml/Antipatterns__conceptual__58b73f2.puml)

The UML diagram has been generated using enhanced analysis with UML glossary knowledge, providing accurate visualization of the conceptual concept described in this document.

### 📋 Technical Summary
**File:** [Antipatterns__58b73f2.md](doc/skills/Antipatterns__58b73f2.md)

The technical summary contains structured metadata, key insights, and AI-optimized content with UML context for automated processing.

### 📚 UML Glossary
**Reference:** [skills/uml-glossary.md](skills/uml-glossary.md)

The comprehensive UML glossary provides definitions and explanations of UML concepts, relationships, and diagram types used in this analysis.

## Key Concepts
- **Anti**
    - **Patterns**
    - **This**
    - **Model**
    - **First**
    - **Design**
    - **Description**
    - **Defining**
    - **Why**
    - **Rejected**
    - **Freezes**
    - **Inverts**
    - **Preferred**
    - **Alternative**
    - **Start**
    - **Enumerated**
    - **Artifact**
    - **Types**
    - **Restricting**
    - **KnowledgeArtifact**
    - **Encourages**
    - **Forces**
    - **Open**
    - **Executable**
    - **Semantics**
    - **Treating**
    - **Conflates**
    - **Breaks**
    - **Artifacts**

## Main Takeaways
- Freezes assumptions too early
    - Inverts the transformation‑first philosophy
    - Encourages premature standardization
    - Forces misclassification of novel insights
    - Conflates understanding with execution

## UML Analysis Notes

This document was processed using UML glossary knowledge, enabling:
- Accurate diagram type classification
- Enhanced understanding of UML terminology
- Improved visualization based on UML standards
- Better context for technical documentation

## Original Content

---

# MCP-UI Anti‑Patterns

This document captures patterns that were considered and rejected.

Anti‑patterns are first‑class knowledge artifacts: they prevent regression and clarify intent.

## AP‑001 — Model‑First Design

**Description**
Defining rigid models before observing real usage.

**Why Rejected**
- Freezes assumptions too early
- Inverts the transformation‑first philosophy

**Preferred Alternative**
Start with transformations derived from usage; allow models to emerge.

---

## AP‑002 — Enumerated Artifact Types

**Description**
Restricting `KnowledgeArtifact.type` to a fixed enum.

**Why Rejected**
- Encourages premature standardization
- Forces misclassification of novel insights

**Preferred Alternative**
Open‑ended string types, stabilized later if needed.

---

## AP‑003 — Executable Semantics

**Description**
Treating MCP‑UI artifacts as instructions to be run.

**Why Rejected**
- Conflates understanding with execution
- Breaks human‑ and LLM‑reasoning symmetry

**Preferred Alternative**
Artifacts describe reality; execution lives elsewhere.

