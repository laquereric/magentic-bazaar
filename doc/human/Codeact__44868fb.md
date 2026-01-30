# Codeact

> **Document Analysis:** This document has been processed through the enhanced ingest workflow with UML glossary integration and classified as a **activity** type (behavioral subtype).

## Document Overview

**Source:** CodeAct.md  
**Processed:** 2026-01-30 05:22:19  
**Git SHA:** a1e3cd6a168ef4053064feb0d008d9776799fd73  
**UUID7:** 44868fb  
**Word Count:** 273 words  
**Main Sections:**   
**UML Classification:** activity (behavioral)  

## Visual Resources

### 🎯 UML Diagram
**Type:** Activity Diagram  
**Subtype:** behavioral  
**File:** [Codeact__activity__44868fb.puml](doc/uml/Codeact__activity__44868fb.puml)

The UML diagram has been generated using enhanced analysis with UML glossary knowledge, providing accurate visualization of the activity concept described in this document.

### 📋 Technical Summary
**File:** [Codeact__44868fb.md](doc/skills/Codeact__44868fb.md)

The technical summary contains structured metadata, key insights, and AI-optimized content with UML context for automated processing.

### 📚 UML Glossary
**Reference:** [skills/uml-glossary.md](skills/uml-glossary.md)

The comprehensive UML glossary provides definitions and explanations of UML concepts, relationships, and diagram types used in this analysis.

## Key Concepts
- **Speech**
    - **Natural**
    - **Language**
    - **Processing**
    - **CodeAct**
    - **Your**
    - **Agent**
    - **Acts**
    - **Better**
    - **Generating**
    - **Code**
    - **AuthorsXingyao**
    - **Wang**
    - **Yangyi**
    - **Chen**
    - **Lifan**
    - **Yuan**
    - **Yizhe**
    - **Zhang**
    - **Yunzhu**
    - **Li**
    - **Hao**
    - **Peng**
    - **Ji**
    - **Heng**
    - **View**
    - **Copy**
    - **Bibtex**
    - **Large**
    - **Model**
    - **This**
    - **Python**
    - **Integrated**
    - **Our**
    - **Bank**
    - **The**
    - **To**
    - **CodeActInstruct**
    - **We**
    - **CodeActAgent**
    - **Mistral**
    - **Related**

## Main Takeaways


## UML Analysis Notes

This document was processed using UML glossary knowledge, enabling:
- Accurate diagram type classification
- Enhanced understanding of UML terminology
- Improved visualization based on UML standards
- Better context for technical documentation

## Original Content

---

Speech and Natural Language Processing | conferenceICML
content typepaper | publishedJuly 2024
CodeAct: Your LLM Agent Acts Better when Generating Code
AuthorsXingyao Wang, Yangyi Chen, Lifan Yuan, Yizhe Zhang, Yunzhu Li, Hao Peng, Ji Heng

View publication

Copy Bibtex



Large Language Model (LLM) agents, capable of performing a broad range of actions, such as invoking tools and controlling robots, show great potential in tackling real-world challenges. LLM agents are typically prompted to produce actions by generating JSON or text in a pre-defined format, which is usually limited by constrained action space (e.g., the scope of pre-defined tools) and restricted flexibility (e.g., inability to compose multiple tools). This work proposes to use executable Python code to consolidate LLM agents’ actions into a unified action space (CodeAct). Integrated with a Python interpreter, CodeAct can execute code actions and dynamically revise prior actions or emit new actions upon new observations through multi-turn interactions. Our extensive analysis of 17 LLMs on API-Bank and a newly curated benchmark shows that CodeAct outperforms widely used alternatives (up to 20% higher success rate). The encouraging performance of CodeAct motivates us to build an open-source LLM agent that interacts with environments by executing interpretable code and collaborates with users using natural language. To this end, we collect an instruction-tuning dataset CodeActInstruct that consists of 7k multi-turn interactions using CodeAct. We show that it can be used with existing data to improve models in agent-oriented tasks without compromising their general capability. CodeActAgent, finetuned from Llama2 and Mistral, is integrated with Python interpreter and uniquely tailored to perform sophisticated tasks (e.g., model training) using existing libraries and autonomously self-debug.

Related readings and updates.

