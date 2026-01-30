# Comparison: "Human-in-the-Loop" Philosophies

While both OpenCode and the Microsoft Agent Framework use the "human-in-the-loop" concept, its implementation and purpose are fundamentally different, reflecting their distinct target audiences.

| Aspect | **OpenCode (The Developer's Co-Pilot)** | **Microsoft Agent Framework (The Business Process Engine)** |
| :--- | :--- | :--- |
| **Who is the "Human"?** | The **developer** using the tool. | A **business user** or **manager** responsible for a process. |
| **What is being approved?** | **Code-level actions:** "Should I apply this diff?", "Is this plan to fix the bug correct?", "Should I execute this shell command?" | **Business-level actions:** "Should I approve this $50,000 payment?", "Is it okay to provision this new cloud server?", "Should I send this email to the customer?" |
| **Where does it happen?** | Inside the **terminal** or **code editor**. | Inside a **business application** (e.g., Microsoft Teams, a web dashboard, an email client). |
| **Why is it needed?** | For **control and correctness**. The developer is the expert and must ensure the AI's output is correct and safe before it's committed to the codebase. | For **governance and compliance**. The business needs to enforce its rules and provide an audit trail for sensitive operations. |
| **Frequency** | High-frequency, granular interactions. Happens many times during a single coding session. | Low-frequency, high-impact interactions. Happens only at critical checkpoints in a business process. |
| **Analogy** | It's like a **spell-checker for code**. It suggests a change, and you decide whether to accept it. | It's like a **manager's signature**. The process stops and waits for an authorized human to give the final go-ahead. |
