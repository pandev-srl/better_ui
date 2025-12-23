// Import and register all your controllers from the importmap under controllers/*

import { application } from "controllers/application";

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";

// Import BetterUi controllers from npm package
import { registerControllers } from "@pandev-srl/better-ui";

// Load local dummy app controllers (if any)
eagerLoadControllersFrom("controllers", application);

// Register BetterUi controllers from npm package
registerControllers(application);
