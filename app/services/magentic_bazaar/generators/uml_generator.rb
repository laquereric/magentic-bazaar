# frozen_string_literal: true

module MagenticBazaar
  module Generators
    class UmlGenerator
      attr_reader :glossary

      def initialize(glossary = {})
        @glossary = glossary
      end

      def generate(content, title, analysis)
        puml = case analysis[:type]
               when "class_diagram"   then generate_class_diagram(title)
               when "inheritance"     then generate_inheritance_diagram(title)
               when "composition"     then generate_composition_diagram(title)
               when "use_case"        then generate_use_case_diagram(title)
               when "sequence"        then generate_sequence_diagram(title)
               when "activity"        then generate_activity_diagram(title)
               when "state_machine"   then generate_state_machine_diagram(title)
               when "component"       then generate_component_diagram(title)
               when "deployment"      then generate_deployment_diagram(title)
               else                        generate_conceptual_diagram(title)
               end

        add_metadata_header(puml, analysis)
      end

      private

      def add_metadata_header(puml, analysis)
        header = <<~HEADER
          ' Generated at: #{Time.now.strftime('%Y-%m-%d %H:%M:%S')}
          ' UML Type: #{analysis[:type]}

        HEADER
        header + puml
      end

      def generate_class_diagram(title)
        <<~UML
          @startuml
          title #{title} - Class Diagram

          ' Sample classes based on UML concepts
          class System {
            -name: String
            -version: String
            +initialize()
            +process()
            +shutdown()
          }

          class Component {
            -id: String
            -type: String
            +execute()
            +validate()
          }

          class Interface {
            <<interface>>
            +connect()
            +disconnect()
          }

          System "1" *-- "many" Component : composition
          Component ..|> Interface : realization
          Component "1" --> "many" Component : association

          @enduml
        UML
      end

      def generate_inheritance_diagram(title)
        <<~UML
          @startuml
          title #{title} - Inheritance Hierarchy

          abstract class AbstractEntity {
            #id: String
            #created: DateTime
            +getId(): String
          }

          class User {
            -username: String
            -email: String
            +login()
            +logout()
          }

          class Admin {
            -permissions: Array
            +manageUsers()
          }

          class Guest {
            -sessionId: String
            +browse()
          }

          AbstractEntity <|-- User
          User <|-- Admin
          User <|-- Guest

          note right of AbstractEntity
            Abstract base class
            using Generalization
          end note

          @enduml
        UML
      end

      def generate_composition_diagram(title)
        <<~UML
          @startuml
          title #{title} - Composition & Aggregation

          class House {
            -address: String
            +addRoom()
            +removeRoom()
          }

          class Room {
            -size: Float
            -type: String
            +getSize()
          }

          class Department {
            -name: String
            +addProfessor()
          }

          class Professor {
            -name: String
            -specialty: String
            +teach()
          }

          ' Composition: strong relationship
          House "1" *-- "many" Room : composition

          ' Aggregation: weak relationship
          Department "1" o-- "many" Professor : aggregation

          note right of House
            Composition: Room cannot
            exist without House
          end note

          note right of Department
            Aggregation: Professor can
            exist independently
          end note

          @enduml
        UML
      end

      def generate_use_case_diagram(title)
        <<~UML
          @startuml
          title #{title} - Use Case Diagram

          actor User
          actor Administrator
          actor System

          rectangle "System Boundary" {
            User -- (Login)
            User -- (Browse Content)
            User -- (Search)
            Administrator -- (Manage Users)
            Administrator -- (Configure System)
            System -- (Process Data)
            System -- (Generate Reports)
          }

          User .> Administrator : inheritance

          note right of User
            Primary actor
            interacts with system
          end note

          @enduml
        UML
      end

      def generate_sequence_diagram(title)
        <<~UML
          @startuml
          title #{title} - Sequence Diagram

          actor User
          participant "Frontend" as frontend
          participant "API Gateway" as api
          participant "Service" as service
          database "Database" as db

          User -> frontend: Request Action
          frontend -> api: HTTP Request
          api -> service: Process Request
          service -> db: Query Data
          db --> service: Return Results
          service --> api: Processed Response
          api --> frontend: JSON Response
          frontend --> User: Display Results

          note over User,db
            Typical interaction sequence
            showing message flow
          end note

          @enduml
        UML
      end

      def generate_activity_diagram(title)
        <<~UML
          @startuml
          title #{title} - Activity Diagram

          start

          :Receive Input;
          if (Input Valid?) then (yes)
            :Process Data;
            fork
              :Validate Results;
            fork again
              :Log Activity;
            end fork
            :Generate Output;
            :Send Response;
          else (no)
            :Log Error;
            :Return Error Message;
          endif

          stop

          note right of "Process Data"
            Parallel processing
            with validation
          end note

          @enduml
        UML
      end

      def generate_state_machine_diagram(title)
        <<~UML
          @startuml
          title #{title} - State Machine Diagram

          [*] --> Inactive

          state Inactive
          state Active
          state Processing
          state Error
          state Maintenance

          Inactive --> Active : activate()
          Active --> Processing : startProcess()
          Processing --> Active : complete()
          Processing --> Error : failure()
          Error --> Active : recover()
          Active --> Inactive : deactivate()
          Active --> Maintenance : maintain()
          Maintenance --> Active : resume()

          note right of Processing
            Processing state
            handles core logic
          end note

          @enduml
        UML
      end

      def generate_component_diagram(title)
        <<~UML
          @startuml
          title #{title} - Component Diagram

          package "Frontend" {
            [UI Component] as ui
            [API Client] as client
          }

          package "Backend" {
            [API Gateway] as gateway
            [Service Layer] as service
            [Data Access] as data
          }

          package "Infrastructure" {
            [Database] as db
            [Cache] as cache
          }

          ui --> client
          client --> gateway
          gateway --> service
          service --> data
          data --> db
          service --> cache

          note right of gateway
            Central component
            routes requests
          end note

          @enduml
        UML
      end

      def generate_deployment_diagram(title)
        <<~UML
          @startuml
          title #{title} - Deployment Diagram

          node "Web Server" {
            artifact "Web App" as webapp
          }

          node "App Server" {
            artifact "API Service" as apiservice
          }

          node "Database Server" {
            artifact "Database" as database
          }

          node "Cache Server" {
            artifact "Redis Cache" as redis
          }

          webapp --> apiservice : HTTPS
          apiservice --> database : JDBC
          apiservice --> redis : TCP

          note right of apiservice
            Deployed as container
            connects to multiple
            infrastructure components
          end note

          @enduml
        UML
      end

      def generate_conceptual_diagram(title)
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

          note over source,output
            High-level workflow visualization
            based on document analysis
          end note

          @enduml
        UML
      end
    end
  end
end
