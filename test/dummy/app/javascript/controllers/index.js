// Import and register all your controllers from the importmap under controllers/*

import { application } from "controllers/application";

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";

// Load local dummy app controllers (if any)
eagerLoadControllersFrom("controllers", application);

// Load BetterUi engine controllers
eagerLoadControllersFrom("controllers/better_ui", application);
