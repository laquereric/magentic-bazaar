# frozen_string_literal: true

module MagenticBazaar
  class Engine < ::Rails::Engine
    isolate_namespace MagenticBazaar

    initializer "magentic_bazaar.default_configuration" do
      MagenticBazaar.configuration ||= MagenticBazaar::Configuration.new
      MagenticBazaar.configuration.skills_path ||= MagenticBazaar.gem_root.join("skills")
    end

    initializer "magentic_bazaar.configure_multistore", after: :load_config_initializers do
      if MagenticBazaar.configuration&.multistore_enabled
        stores_config = MagenticBazaar.configuration.multistore_stores || []

        next if stores_config.empty?

        ActiveSupport.on_load(:active_record) do
          [MagenticBazaar::Document, MagenticBazaar::Skill, MagenticBazaar::UmlDiagram, MagenticBazaar::McpServer, MagenticBazaar::McpProvider].each do |klass|
            klass.multistore_registry = RailsMultistore::StoreRegistry.new
            stores_config.each do |store_cfg|
              klass.multistore_registry.store(store_cfg[:name], store_cfg)
            end
          end
        end
      end
    end
  end
end
