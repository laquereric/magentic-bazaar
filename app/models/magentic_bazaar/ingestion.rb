# frozen_string_literal: true

module MagenticBazaar
  class Ingestion < ActiveRecord::Base
    self.table_name = "magentic_bazaar_ingestions"

    has_many :documents, class_name: "MagenticBazaar::Document",
             foreign_key: :ingestion_id, dependent: :nullify

    validates :direction, presence: true, inclusion: { in: %w[forward undo] }

    scope :running, -> { where(status: "running") }

    def complete!
      update!(status: "completed")
    end

    def fail!(message)
      update!(status: "failed", error_log: message)
    end
  end
end
