# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

# Pin BetterUi package from vendor (symlinked to built dist)
pin "@pandev-srl/better-ui", to: "better-ui.js"

# Pin dummy app controllers explicitly
pin_all_from "app/javascript/controllers", under: "controllers"
