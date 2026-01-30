# frozen_string_literal: true

module MagenticBazaar
  class IngestJob < ActiveJob::Base
    queue_as { MagenticBazaar.configuration&.queue_name || :magentic_bazaar }

    def perform(direction = "forward")
      case direction
      when "undo"
        UndoPipeline.new.call
      else
        IngestPipeline.new.call
      end
    end
  end
end
