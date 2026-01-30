# frozen_string_literal: true

module MagenticBazaar
  class Document < ActiveRecord::Base
    self.table_name = "magentic_bazaar_documents"

    include RailsMultistore::Model

    belongs_to :ingestion, class_name: "MagenticBazaar::Ingestion", optional: true
    has_one :skill, class_name: "MagenticBazaar::Skill", dependent: :destroy
    has_one :uml_diagram, class_name: "MagenticBazaar::UmlDiagram", dependent: :destroy

    validates :title, presence: true
    validates :original_filename, presence: true
    validates :uuid7, presence: true, uniqueness: true, length: { is: 7 }

    scope :pending,  -> { where(status: "pending") }
    scope :ingested, -> { where(status: "ingested") }

    after_commit :push_to_stores, on: [:create, :update],
                 if: -> { MagenticBazaar.configuration&.multistore_enabled }

    private

    def push_to_stores
      multistore_push if self.class.multistore_registry
    end
  end
end
