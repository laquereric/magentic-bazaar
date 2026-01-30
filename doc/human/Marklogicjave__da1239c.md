# Marklogicjave

> **Document Analysis:** This document has been processed through the enhanced ingest workflow with UML glossary integration and classified as a **conceptual** type (general subtype).

## Document Overview

**Source:** MarklogicJave.md  
**Processed:** 2026-01-30 05:22:19  
**Git SHA:** a1e3cd6a168ef4053064feb0d008d9776799fd73  
**UUID7:** da1239c  
**Word Count:** 577 words  
**Main Sections:**   
**UML Classification:** conceptual (general)  

## Visual Resources

### 🎯 UML Diagram
**Type:** Conceptual Overview  
**Subtype:** general  
**File:** [Marklogicjave__conceptual__da1239c.puml](doc/uml/Marklogicjave__conceptual__da1239c.puml)

The UML diagram has been generated using enhanced analysis with UML glossary knowledge, providing accurate visualization of the conceptual concept described in this document.

### 📋 Technical Summary
**File:** [Marklogicjave__da1239c.md](doc/skills/Marklogicjave__da1239c.md)

The technical summary contains structured metadata, key insights, and AI-optimized content with UML context for automated processing.

### 📚 UML Glossary
**Reference:** [skills/uml-glossary.md](skills/uml-glossary.md)

The comprehensive UML glossary provides definitions and explanations of UML concepts, relationships, and diagram types used in this analysis.

## Key Concepts
- **The**
    - **MarkLogic**
    - **Java**
    - **Client**
    - **Write**
    - **Query**
    - **Project**
    - **Patch**
    - **Use**
    - **Optimistic**
    - **Locking**
    - **Execute**
    - **Call**
    - **Data**
    - **Services**
    - **System**
    - **Requirements**
    - **As**
    - **Prior**
    - **For**
    - **Compatibility**
    - **Matrix**
    - **QuickStart**
    - **To**
    - **Maven**
    - **Gradle**
    - **Next**
    - **Five**
    - **Minutes**
    - **Full**
    - **Application**
    - **Developer**
    - **Guide**
    - **JavaDoc**
    - **Including**
    - **Jakarta**
    - **Binding**
    - **If**
    - **You**
    - **Support**
    - **Engineering**
    - **Apache**
    - **It**
    - **Server**
    - **Everyone**
    - **GitHub**
    - **This**
    - **However**
    - **In**
    - **Please**

## Main Takeaways


## UML Analysis Notes

This document was processed using UML glossary knowledge, enabling:
- Accurate diagram type classification
- Enhanced understanding of UML terminology
- Improved visualization based on UML standards
- Better context for technical documentation

## Original Content

---

https://github.com/marklogic/java-client-api

The MarkLogic Java Client
The MarkLogic Java Client makes it easy to write, read, delete, and find documents in a MarkLogic database. The client requires connecting to a MarkLogic REST API app server and is ideal for applications wishing to build upon the MarkLogic REST API.

The client supports the following core features of the MarkLogic database:

Write and read binary, JSON, text, and XML documents.
Query data structure trees, marked-up text, and all the hybrids in between those extremes.
Project values, tuples, and triples from hierarchical documents and aggregate over them.
Patch documents with partial updates.
Use Optimistic Locking to detect contention without creating locks on the server.
Execute ACID modifications so the change either succeeds or throws an exception.
Execute multi-statement transactions so changes to multiple documents succeed or fail together.
Call Data Services via a Java interface on the client for data functionality implemented by an endpoint on the server.
System Requirements
As of the 8.0.0 release, the Java Client requires Java 17 or Java 21.

Prior releases are compatible with Java 8, 11, 17, and 21.

For compatibility with MarkLogic server versions, please see the Compatibility Matrix.

QuickStart
To use the client in your Maven project, include the following in your pom.xml file:

<dependency>
    <groupId>com.marklogic</groupId>
    <artifactId>marklogic-client-api</artifactId>
    <version>8.0.0</version>
</dependency>
To use the client in your Gradle project, include the following in your build.gradle file:

dependencies {
    implementation "com.marklogic:marklogic-client-api:8.0.0"
}
Next, read The Java API in Five Minutes to get started.

Full documentation is available at:

Java Application Developer's Guide
JavaDoc
Including JAXB support
As of the 7.0.0 release, the client now depends on the Jakarta XML Binding API instead of the older JAXB API. If you are using Java 11 or higher, you no longer need to declare additional dependencies in order to use Jakarta XML Binding. If you wish to use the older JAXB APIs - i.e. those in the javax.xml.bind package instead of jakarta.xml.bind - you are free to include those as dependencies in your application; they will not conflict with the 7.0.0 release of the Java Client.

JAXB support in 6.x releases and older
If you are using Java Client 6.x or older and also Java 11 or higher, and you wish to use JAXB with the Java client, you will need to include JAXB API and implementation dependencies as those are no longer included in Java 11 and higher.

For Maven, include the following in your pom.xml file:

<dependency>
    <groupId>javax.xml.bind</groupId>
    <artifactId>jaxb-api</artifactId>
    <version>2.3.1</version>
</dependency>
<dependency>
    <groupId>org.glassfish.jaxb</groupId>
    <artifactId>jaxb-runtime</artifactId>
    <version>2.3.2</version>
</dependency>
<dependency>
    <groupId>org.glassfish.jaxb</groupId>
    <artifactId>jaxb-core</artifactId>
    <version>2.3.0.1</version>
</dependency>
For Gradle, include the following in your build.gradle file (this can be included in the same dependencies block as the one that includes the marklogic-client-api dependency):

dependencies {
    implementation "javax.xml.bind:jaxb-api:2.3.1"
    implementation "org.glassfish.jaxb:jaxb-runtime:2.3.2"
    implementation "org.glassfish.jaxb:jaxb-core:2.3.0.1"
}
You are free to use any implementation of JAXB that you wish, but you need to ensure that you're using a JAXB implementation that corresponds to the javax.xml.bind interfaces.

Support
The MarkLogic Java Client is maintained by MarkLogic Engineering and is made available under the Apache 2.0 license. It is designed for use in production applications with MarkLogic Server. Everyone is encouraged to file bug reports, feature requests, and pull requests through GitHub. This input is critical and will be carefully considered. However, we can’t promise a specific resolution or timeframe for any request. In addition, MarkLogic provides technical support for release tags of the Java Client to licensed customers. Please visit our support guide for more information on technical support.
