# frozen_string_literal: true

module MagenticBazaar
  class SkillProvider < ActiveRecord::Base
    self.table_name = "magentic_bazaar_skill_providers"

    include RailsMultistore::Model

    belongs_to :document, class_name: "MagenticBazaar::Document", optional: true
    belongs_to :mcp_provider, class_name: "MagenticBazaar::McpProvider", optional: true

    validates :name, presence: true

    serialize :args, coder: JSON
    serialize :env_vars, coder: JSON
    serialize :tools, coder: JSON

    scope :active, -> { where(active: true) }
    scope :by_status, ->(status) { where(status: status) }

    after_commit :push_to_stores, on: [:create, :update],
                 if: -> { MagenticBazaar.configuration&.multistore_enabled }

    private

    def push_to_stores
      multistore_push if self.class.multistore_registry
    end
  end
end
