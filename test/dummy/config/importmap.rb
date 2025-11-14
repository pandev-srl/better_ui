# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

pin_all_from BetterUi::Engine.root.join("app/javascript/controllers/better_ui"),
             under: "controllers/better_ui",
             preload: true

# Pin dummy app controllers explicitly
pin_all_from "app/javascript/controllers", under: "controllers"
