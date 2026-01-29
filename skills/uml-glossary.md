# UML Glossary Skill

## Description
Provides comprehensive definitions and explanations of Unified Modeling Language (UML) concepts, relationships, and diagram types.

## Skill Data

### Core UML Concepts

| Term | Definition |
| --- | --- |
| **Class** | A blueprint for creating objects. It defines a set of attributes and methods that the objects of the class will have. |
| **Object** | An instance of a class. It has a state (defined by its attributes) and behavior (defined by its methods). |
| **Attribute** | A named property of a class that describes a value held by each object of the class. |
| **Operation** | A service that can be requested from an object to affect its behavior. An operation is an abstraction of a method. |
| **Interface** | A collection of operations that specify a service of a class or component. It defines a set of behaviors that an implementing class must provide. |
| **Component** | A modular part of a system that encapsulates its contents and whose manifestation is replaceable within its environment. |
| **Package** | A general-purpose mechanism for organizing elements into groups. It helps to organize complex models by grouping related elements. |

### Relationships in UML

| Relationship | Definition | Example |
| --- | --- | --- |
| **Inheritance (Generalization)** | A relationship between a general class (superclass) and a more specific class (subclass). The subclass inherits attributes and operations from the superclass. | A `Car` class inheriting from a `Vehicle` class. |
| **Realization (Implementation)** | A relationship between an interface and a class that implements it. The class must provide an implementation for all the operations defined in the interface. | A `Car` class implementing the `IDrivable` interface. |
| **Composition** | A strong "whole-part" relationship where the part cannot exist without the whole. If the whole is destroyed, the part is also destroyed. | A `House` is composed of `Rooms`. If the house is demolished, the rooms cease to exist. |
| **Aggregation** | A weaker "whole-part" relationship where the part can exist independently of the whole. | A `Department` has `Professors`. If the department is closed, the professors can still exist. |
| **Association** | A structural relationship that indicates that objects of one class are connected to objects of another. | A `Student` is associated with a `Course`. |
| **Dependency** | A relationship where a change in one element (the supplier) may affect another element (the client). | A `ReportGenerator` class depends on a `Database` class to fetch data. |

Relationship strength (strongest to weakest): Inheritance → Implementation → Composition → Aggregation → Association → Dependency

### Structural Diagrams

| Diagram Type | Description |
| --- | --- |
| **Class Diagram** | The most common diagram type, it describes the structure of a system by showing its classes, their attributes, operations, and the relationships among them. |
| **Component Diagram** | Shows the organization and dependencies among a set of components. |
| **Deployment Diagram** | Describes the hardware used in system implementations and the execution environments and artifacts deployed on the hardware. |
| **Object Diagram** | Shows a set of objects and their relationships at a specific point in time. It is often used to illustrate data structures. |
| **Package Diagram** | Shows how a system is divided into logical groupings and the dependencies among these groups. |
| **Profile Diagram** | A specialized diagram that defines custom stereotypes, tagged values, and constraints for a specific domain or platform. |
| **Composite Structure Diagram** | Shows the internal structure of a classifier, including its parts and the connectors between them. |

### Behavioral Diagrams

| Diagram Type | Description |
| --- | --- |
| **Use Case Diagram** | Describes the functional requirements of the system from the user's perspective. It shows the interactions between users (actors) and the system. |
| **Activity Diagram** | Graphically represents workflows of stepwise activities and actions with support for choice, iteration, and concurrency. |
| **State Machine Diagram** | Models the behavior of a single object, specifying the sequence of states it goes through during its lifetime in response to events. |
| **Sequence Diagram** | An interaction diagram that shows how processes operate with one another and in what order. |
| **Communication Diagram** | An interaction diagram that emphasizes the structural organization of the objects that send and receive messages. (Formerly known as a collaboration diagram in UML 1.x). |
| **Interaction Overview Diagram** | A type of activity diagram in which the nodes represent interaction diagrams. |
| **Timing Diagram** | An interaction diagram that shows the timing constraints on the behavior of objects over a specific period. |

## Usage Instructions

This skill provides quick reference information about UML concepts. Users can ask questions about:
- UML terminology and definitions
- Types of relationships and their usage
- Different diagram types and when to use them
- Comparisons between UML concepts

## Sources
- Wikipedia: Glossary of Unified Modeling Language terms
- Visual Paradigm: UML class diagram relationships
- Creately: UML diagram types and examples