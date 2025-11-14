# frozen_string_literal: true

# Pin all BetterUi Stimulus controllers for eager loading
pin_all_from BetterUi::Engine.root.join("app/javascript/controllers/better_ui"),
             under: "controllers/better_ui",
             preload: true
