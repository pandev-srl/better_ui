Rails.application.routes.draw do
  # Mount BetterUi engine
  mount BetterUi::Engine => "/better_ui"

  # Demo routes
  get "demos", to: "demos#index", as: :demos
  get "demos/buttons", to: "demos#buttons", as: :demos_buttons
  get "demos/cards", to: "demos#cards", as: :demos_cards
  get "demos/alerts", to: "demos#alerts", as: :demos_alerts
  get "demos/forms", to: "demos#forms", as: :demos_forms

  # Set root route
  root "demos#index"
end
