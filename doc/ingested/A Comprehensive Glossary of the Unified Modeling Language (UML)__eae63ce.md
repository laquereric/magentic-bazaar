# A Comprehensive Glossary of the Unified Modeling Language (UML)

**Author:** Manus AI

**Date:** January 29, 2026

## Introduction

The Unified Modeling Language (UML) is a standardized modeling language used in software engineering to visualize, specify, construct, and document the artifacts of a software system. It provides a set of graphical notations to create visual models of software-intensive systems. This glossary offers a comprehensive overview of key UML terminology, including the various diagram types and the relationships between different concepts. The information presented here is compiled from various authoritative sources to ensure accuracy and clarity.

## Core UML Concepts

This section defines the fundamental building blocks of the Unified Modeling Language. These concepts are essential for understanding the structure and behavior of object-oriented systems.

| Term | Definition |
| --- | --- |
| **Class** | A blueprint for creating objects. It defines a set of attributes and methods that the objects of the class will have. [1] |
| **Object** | An instance of a class. It has a state (defined by its attributes) and behavior (defined by its methods). [1] |
| **Attribute** | A named property of a class that describes a value held by each object of the class. [1] |
| **Operation** | A service that can be requested from an object to affect its behavior. An operation is an abstraction of a method. [1] |
| **Interface** | A collection of operations that specify a service of a class or component. It defines a set of behaviors that an implementing class must provide. [2] |
| **Component** | A modular part of a system that encapsulates its contents and whose manifestation is replaceable within its environment. [1] |
| **Package** | A general-purpose mechanism for organizing elements into groups. It helps to organize complex models by grouping related elements. [3] |

## Relationships in UML

UML defines several types of relationships to represent the connections between different elements in a model. These relationships are crucial for understanding the static structure and dynamic behavior of a system. The main types of relationships are summarized in the table below.

| Relationship | Definition | Example |
| --- | --- | --- |
| **Inheritance (Generalization)** | A relationship between a general class (superclass) and a more specific class (subclass). The subclass inherits attributes and operations from the superclass. [2] | A `Car` class inheriting from a `Vehicle` class. |
| **Realization (Implementation)** | A relationship between an interface and a class that implements it. The class must provide an implementation for all the operations defined in the interface. [2] | A `Car` class implementing the `IDrivable` interface. |
| **Composition** | A strong "whole-part" relationship where the part cannot exist without the whole. If the whole is destroyed, the part is also destroyed. [2] | A `House` is composed of `Rooms`. If the house is demolished, the rooms cease to exist. |
| **Aggregation** | A weaker "whole-part" relationship where the part can exist independently of the whole. [2] | A `Department` has `Professors`. If the department is closed, the professors can still exist. |
| **Association** | A structural relationship that indicates that objects of one class are connected to objects of another. [1] | A `Student` is associated with a `Course`. |
| **Dependency** | A relationship where a change in one element (the supplier) may affect another element (the client). [1] | A `ReportGenerator` class depends on a `Database` class to fetch data. |

The strength of these relationships, from strongest to weakest, is generally considered to be: **Inheritance → Implementation → Composition → Aggregation → Association → Dependency**. [2]

## UML Diagram Types

UML diagrams are categorized into two main types: **Structural Diagrams** and **Behavioral Diagrams**. Structural diagrams show the static structure of the system, while behavioral diagrams show the dynamic behavior of the system components. [3]

### Structural Diagrams

Structural diagrams represent the static aspect of the system. They show the elements that make up the system and their relationships.

| Diagram Type | Description |
| --- | --- |
| **Class Diagram** | The most common diagram type, it describes the structure of a system by showing its classes, their attributes, operations, and the relationships among them. [3] |
| **Component Diagram** | Shows the organization and dependencies among a set of components. [3] |
| **Deployment Diagram** | Describes the hardware used in system implementations and the execution environments and artifacts deployed on the hardware. [3] |
| **Object Diagram** | Shows a set of objects and their relationships at a specific point in time. It is often used to illustrate data structures. [3] |
| **Package Diagram** | Shows how a system is divided into logical groupings and the dependencies among these groups. [3] |
| **Profile Diagram** | A specialized diagram that defines custom stereotypes, tagged values, and constraints for a specific domain or platform. [3] |
| **Composite Structure Diagram** | Shows the internal structure of a classifier, including its parts and the connectors between them. [3] |

### Behavioral Diagrams

Behavioral diagrams illustrate the dynamic behavior of the system. They show how the system responds to events and how its components interact over time.

| Diagram Type | Description |
| --- | --- |
| **Use Case Diagram** | Describes the functional requirements of the system from the user's perspective. It shows the interactions between users (actors) and the system. [3] |
| **Activity Diagram** | Graphically represents workflows of stepwise activities and actions with support for choice, iteration, and concurrency. [3] |
| **State Machine Diagram** | Models the behavior of a single object, specifying the sequence of states it goes through during its lifetime in response to events. [3] |
| **Sequence Diagram** | An interaction diagram that shows how processes operate with one another and in what order. [3] |
| **Communication Diagram** | An interaction diagram that emphasizes the structural organization of the objects that send and receive messages. (Formerly known as a collaboration diagram in UML 1.x). [3] |
| **Interaction Overview Diagram** | A type of activity diagram in which the nodes represent interaction diagrams. [3] |
| **Timing Diagram** | An interaction diagram that shows the timing constraints on the behavior of objects over a specific period. [3] |

## References

[1] Wikipedia. (n.d.). *Glossary of Unified Modeling Language terms*. Retrieved from https://en.wikipedia.org/wiki/Glossary_of_Unified_Modeling_Language_terms

[2] Visual Paradigm. (2022, February 9). *What are the six types of relationships in UML class diagrams?*. Visual Paradigm Blog. Retrieved from https://blog.visual-paradigm.com/what-are-the-six-types-of-relationships-in-uml-class-diagrams/

[3] Creately. (2025, October 17). *UML Diagram Types | Learn About All 14 Types of UML Diagrams*. Creately Blog. Retrieved from https://creately.com/blog/diagrams/uml-diagram-types-examples/
