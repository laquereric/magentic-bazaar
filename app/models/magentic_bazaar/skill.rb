# frozen_string_literal: true

module MagenticBazaar
  class Skill < ActiveRecord::Base
    self.table_name = "magentic_bazaar_skills"

    include RailsMultistore::Model

    belongs_to :document, class_name: "MagenticBazaar::Document"

    validates :name, presence: true

    serialize :tags, coder: JSON

    after_commit :push_to_stores, on: [:create, :update],
                 if: -> { MagenticBazaar.configuration&.multistore_enabled }

    private

    def push_to_stores
      multistore_push if self.class.multistore_registry
    end
  end
end
