"Policy as code" in the context of the AI code editor Cursor refers to the use of specific, version-controlled configuration files (known as Cursor Rules and AI-POLICY.txt files) to guide and constrain the behavior of its AI agents. This approach helps enforce security, compliance, and best practices within a project or organization. 
How Policy as Code Works in Cursor
Cursor provides mechanisms for defining policies as code, which are essentially instructions to the AI on how to behave, format code, and adhere to project standards. 
Cursor Rules (.cursor/rules/): These are configuration files (often in Markdown format) that provide persistent context to the AI, guiding it on project-specific patterns, best practices, and constraints.
Scope: Rules can be applied at the user, project, or team/organization level, with project and team rules stored in the repository for version control and team visibility.
Enforcement: The AI treats these rules as guidance for code generation, aiming to improve consistency and quality by reducing the need for manual correction.
Repository-level AI Policy File (AI-POLICY.txt): This is a human-readable file used to define broader governance policies within a repository.
Transparency: It provides an audit trail and allows non-developers (like legal or compliance teams) to review the policies.
Soft Enforcement: This file results in "soft enforcement," typically involving a warning and a choice for the user, rather than a hard block of the operation.
Hard Controls (Deterministic Enforcement): For critical security boundaries, Cursor offers more deterministic controls beyond AI guidance, such as:
Terminal command restrictions and sandboxing.
Enforcement hooks that can block operations at runtime.
Approval workflows for sensitive actions. 
Key Benefits
Consistency: Ensures AI-generated code adheres to established team patterns and best practices.
Compliance & Security: Helps avoid secrets in code, enforces sanitization rules, and prevents the AI from taking unintended or unsafe actions.
Version Control: Policies are managed using standard version control systems (like Git), providing an audit trail and an easy way to revert changes.
Collaboration: Provides a uniform method for managing policies that is understandable by different stakeholders, from developers to security engineers. 
For more details, you can refer to the official Cursor documentation on Rules or their Trust Center for enterprise security specifics. 