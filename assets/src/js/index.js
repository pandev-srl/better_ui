// BetterUi CSS
import "../css/index.css"

// BetterUi Stimulus Controllers
import ButtonController from "./button_controller"
import ActionMessagesController from "./action_messages_controller"
import PasswordInputController from "./forms/password_input_controller"
import DrawerLayoutController from "./drawer/layout_controller"

// Export individual controllers for selective imports
export { ButtonController, ActionMessagesController, PasswordInputController, DrawerLayoutController }

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
  application.register("better-ui--drawer--layout", DrawerLayoutController)
}
