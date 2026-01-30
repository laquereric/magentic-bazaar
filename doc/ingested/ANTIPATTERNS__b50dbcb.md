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
