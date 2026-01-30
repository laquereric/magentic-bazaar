# frozen_string_literal: true

module MagenticBazaar
  class UmlDiagram < ActiveRecord::Base
    self.table_name = "magentic_bazaar_uml_diagrams"

    include RailsMultistore::Model

    belongs_to :document, class_name: "MagenticBazaar::Document"

    validates :diagram_type, presence: true

    after_commit :push_to_stores, on: [:create, :update],
                 if: -> { MagenticBazaar.configuration&.multistore_enabled }

    private

    def push_to_stores
      multistore_push if self.class.multistore_registry
    end
  end
end
