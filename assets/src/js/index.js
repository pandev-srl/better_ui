// BetterUi Stimulus Controllers
// Export individual controllers for selective imports
export { default as ButtonController } from "./button_controller"
export { default as ActionMessagesController } from "./action_messages_controller"
export { default as PasswordInputController } from "./forms/password_input_controller"

/**
 * Register all BetterUi controllers with a Stimulus application
 *
 * @param {Application} application - The Stimulus application instance
 * @example
 *   import { Application } from "@hotwired/stimulus"
 *   import { registerControllers } from "@pandev-srl/better-ui"
 *
 *   const application = Application.start()
 *   registerControllers(application)
 */
export function registerControllers(application) {
  application.register("better-ui--button", ButtonController)
  application.register("better-ui--action-messages", ActionMessagesController)
  application.register("better-ui--forms--password-input", PasswordInputController)
}
