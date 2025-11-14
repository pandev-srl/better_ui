# BetterUi Migration Execution Plan
**Date:** 2024-11-12
**Time:** 14:30
**Planner:** planner-manager

## Executive Summary
This plan provides concrete, actionable tasks for migrating UI components from the Powerbankly application to the BetterUi Rails engine gem. The migration includes 10 Ruby components, 7 ERB templates, 3 Stimulus controllers, and a comprehensive theme system. The gem will distribute ViewComponents only (no CSS files), with host applications responsible for CSS generation via Tailwind v4.

## Functionality Description
The BetterUi gem will provide:
- **10 ViewComponents** with full Tailwind CSS v4 styling
- **UiFormBuilder** for Rails form integration
- **3 Stimulus controllers** for interactive behavior
- **Theme generator** that creates color system in host apps
- **Lookbook integration** for component documentation
- **Dummy app** with full PostCSS/Tailwind setup for development

Key architectural decisions:
- Components use `BetterUi::` namespace
- NO CSS files distributed (only ViewComponents with Tailwind classes)
- Host apps scan `vendor/bundle` for Tailwind classes
- Stimulus controllers use `better-ui--` prefix
- 9-variant color system with full scale (50-950)

## Work Phases

### Phase 1: Setup Dependencies and Infrastructure
**Duration:** 2 hours
**Objective:** Prepare the gem with required dependencies and directory structure

#### Tasks:

1. **Task 1.1:** Update gemspec with required dependencies
   - Description: Add ViewComponent, TailwindMerge, Lookbook, and Importmap dependencies
   - Assigned to: Developer
   - Dependencies: None
   - Deliverables: Updated `better_ui.gemspec` with all dependencies
   - Files to modify:
     - `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/better_ui.gemspec`
   - Code changes:
     ```ruby
     spec.add_dependency "view_component", "~> 4.1"
     spec.add_dependency "tailwind_merge", "~> 0.12"
     spec.add_dependency "lookbook", "~> 2.3"
     spec.add_dependency "importmap-rails"
     ```

2. **Task 1.2:** Create component directory structure
   - Description: Create all necessary directories for components, forms, and JavaScript
   - Assigned to: Developer
   - Dependencies: None
   - Deliverables: Complete directory structure
   - Commands to run:
     ```bash
     mkdir -p /Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/app/components/better_ui
     mkdir -p /Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/app/components/better_ui/forms
     mkdir -p /Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/app/form_builders/better_ui
     mkdir -p /Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/app/javascript/controllers/better_ui/forms
     mkdir -p /Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/spec/components/previews/better_ui/forms
     mkdir -p /Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/lib/generators/better_ui/install/templates
     ```

3. **Task 1.3:** Configure engine for importmap and Lookbook
   - Description: Update engine.rb with importmap and Lookbook configuration
   - Assigned to: Developer
   - Dependencies: Task 1.2
   - Deliverables: Configured engine file
   - Files to modify:
     - `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/lib/better_ui/engine.rb`
   - Add configuration for importmap paths and Lookbook preview paths

4. **Task 1.4:** Create importmap configuration
   - Description: Create config/importmap.rb for JavaScript module mapping
   - Assigned to: Developer
   - Dependencies: Task 1.2
   - Deliverables: Importmap configuration file
   - File to create:
     - `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/config/importmap.rb`

### Phase 2: Migrate Core Ruby Components
**Duration:** 4 hours
**Objective:** Migrate all Ruby component classes with namespace changes

#### Tasks:

1. **Task 2.1:** Migrate ApplicationComponent base class
   - Description: Copy and adapt ApplicationComponent with namespace change to BetterUi::
   - Assigned to: Developer
   - Dependencies: Phase 1 complete
   - Deliverables: Base component class with VARIANTS constant and css_classes helper
   - Source file: `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/app/components/application_component.rb`
   - Target file: `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/app/components/better_ui/application_component.rb`
   - Key changes:
     - Change class to `BetterUi::ApplicationComponent`
     - Preserve VARIANTS constant
     - Preserve css_classes helper with TailwindMerge

2. **Task 2.2:** Migrate ButtonComponent
   - Description: Migrate button component with all variants, sizes, and styles
   - Assigned to: Developer
   - Dependencies: Task 2.1
   - Deliverables: ButtonComponent class and ERB template
   - Source files:
     - `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/app/components/ui/button_component.rb`
     - `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/app/components/ui/button_component/button_component.html.erb`
   - Target files:
     - `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/app/components/better_ui/button_component.rb`
     - `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/app/components/better_ui/button_component/button_component.html.erb`
   - Key changes:
     - Change class namespace to `BetterUi::ButtonComponent`
     - Update Stimulus controller reference from `ui--button-component` to `better-ui--button`

3. **Task 2.3:** Migrate CardComponent
   - Description: Migrate card component with slots for header, body, footer
   - Assigned to: Developer
   - Dependencies: Task 2.1
   - Deliverables: CardComponent class and ERB template
   - Source files:
     - `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/app/components/ui/card_component.rb`
     - `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/app/components/ui/card_component/card_component.html.erb`
   - Target files:
     - `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/app/components/better_ui/card_component.rb`
     - `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/app/components/better_ui/card_component/card_component.html.erb`
   - Key changes:
     - Change class namespace to `BetterUi::CardComponent`

4. **Task 2.4:** Migrate ActionMessagesComponent
   - Description: Migrate action messages component with dismiss functionality
   - Assigned to: Developer
   - Dependencies: Task 2.1
   - Deliverables: ActionMessagesComponent class and ERB template
   - Source files:
     - `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/app/components/ui/action_messages_component.rb`
     - `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/app/components/ui/action_messages_component/action_messages_component.html.erb`
   - Target files:
     - `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/app/components/better_ui/action_messages_component.rb`
     - `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/app/components/better_ui/action_messages_component/action_messages_component.html.erb`
   - Key changes:
     - Change class namespace to `BetterUi::ActionMessagesComponent`
     - Update Stimulus controller reference from `ui--action-messages-component` to `better-ui--action_messages`

5. **Task 2.5:** Migrate Forms::BaseComponent
   - Description: Migrate abstract base class for form components
   - Assigned to: Developer
   - Dependencies: Task 2.1
   - Deliverables: BaseComponent class for forms
   - Source file: `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/app/components/ui/forms/base_component.rb`
   - Target file: `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/app/components/better_ui/forms/base_component.rb`
   - Key changes:
     - Change class namespace to `BetterUi::Forms::BaseComponent`

6. **Task 2.6:** Migrate Forms::TextInputComponent
   - Description: Migrate text input component with prefix/suffix slots
   - Assigned to: Developer
   - Dependencies: Task 2.5
   - Deliverables: TextInputComponent class and ERB template
   - Source files:
     - `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/app/components/ui/forms/text_input_component.rb`
     - `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/app/components/ui/forms/text_input_component/text_input_component.html.erb`
   - Target files:
     - `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/app/components/better_ui/forms/text_input_component.rb`
     - `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/app/components/better_ui/forms/text_input_component/text_input_component.html.erb`
   - Key changes:
     - Change class namespace to `BetterUi::Forms::TextInputComponent`

7. **Task 2.7:** Migrate Forms::NumberInputComponent
   - Description: Migrate number input with min/max/step support
   - Assigned to: Developer
   - Dependencies: Task 2.5
   - Deliverables: NumberInputComponent class and ERB template
   - Source files:
     - `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/app/components/ui/forms/number_input_component.rb`
     - `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/app/components/ui/forms/number_input_component/number_input_component.html.erb`
   - Target files:
     - `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/app/components/better_ui/forms/number_input_component.rb`
     - `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/app/components/better_ui/forms/number_input_component/number_input_component.html.erb`
   - Key changes:
     - Change class namespace to `BetterUi::Forms::NumberInputComponent`

8. **Task 2.8:** Migrate Forms::PasswordInputComponent
   - Description: Migrate password input with visibility toggle
   - Assigned to: Developer
   - Dependencies: Task 2.6
   - Deliverables: PasswordInputComponent class and ERB template
   - Source files:
     - `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/app/components/ui/forms/password_input_component.rb`
     - `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/app/components/ui/forms/password_input_component/password_input_component.html.erb`
   - Target files:
     - `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/app/components/better_ui/forms/password_input_component.rb`
     - `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/app/components/better_ui/forms/password_input_component/password_input_component.html.erb`
   - Key changes:
     - Change class namespace to `BetterUi::Forms::PasswordInputComponent`
     - Update Stimulus controller reference from `ui--forms--password-input-component` to `better-ui--forms--password_input`

9. **Task 2.9:** Migrate Forms::TextareaComponent
   - Description: Migrate textarea component with resize control
   - Assigned to: Developer
   - Dependencies: Task 2.5
   - Deliverables: TextareaComponent class and ERB template
   - Source files:
     - `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/app/components/ui/forms/textarea_component.rb`
     - `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/app/components/ui/forms/textarea_component/textarea_component.html.erb`
   - Target files:
     - `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/app/components/better_ui/forms/textarea_component.rb`
     - `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/app/components/better_ui/forms/textarea_component/textarea_component.html.erb`
   - Key changes:
     - Change class namespace to `BetterUi::Forms::TextareaComponent`

10. **Task 2.10:** Migrate UiFormBuilder
    - Description: Migrate form builder with all helper methods
    - Assigned to: Developer
    - Dependencies: Tasks 2.6-2.9
    - Deliverables: UiFormBuilder class
    - Source file: `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/app/form_builders/ui_form_builder.rb`
    - Target file: `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/app/form_builders/better_ui/ui_form_builder.rb`
    - Key changes:
      - Change class namespace to `BetterUi::UiFormBuilder`
      - Update component references to use BetterUi namespace

### Phase 3: Migrate Stimulus Controllers
**Duration:** 2 hours
**Objective:** Migrate all JavaScript controllers with updated naming

#### Tasks:

1. **Task 3.1:** Migrate button controller
   - Description: Copy and adapt button Stimulus controller
   - Assigned to: Developer
   - Dependencies: Phase 2 complete
   - Deliverables: Button controller with loading state management
   - Source file: `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/app/javascript/components/ui/button_component_controller.js`
   - Target file: `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/app/javascript/controllers/better_ui/button_controller.js`
   - Key changes:
      - Controller identifier: `better-ui--button`
      - Update any internal references

2. **Task 3.2:** Migrate action messages controller
   - Description: Copy and adapt action messages Stimulus controller
   - Assigned to: Developer
   - Dependencies: Phase 2 complete
   - Deliverables: Action messages controller with dismiss functionality
   - Source file: `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/app/javascript/components/ui/action_messages_component_controller.js`
   - Target file: `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/app/javascript/controllers/better_ui/action_messages_controller.js`
   - Key changes:
      - Controller identifier: `better-ui--action_messages`

3. **Task 3.3:** Migrate password input controller
   - Description: Copy and adapt password input Stimulus controller
   - Assigned to: Developer
   - Dependencies: Phase 2 complete
   - Deliverables: Password input controller with visibility toggle
   - Source file: `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/app/javascript/components/ui/forms/password_input_component_controller.js`
   - Target file: `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/app/javascript/controllers/better_ui/forms/password_input_controller.js`
   - Key changes:
      - Controller identifier: `better-ui--forms--password_input`

4. **Task 3.4:** Create controllers index file
   - Description: Create index.js to register all controllers
   - Assigned to: Developer
   - Dependencies: Tasks 3.1-3.3
   - Deliverables: Index file for controller registration
   - File to create: `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/app/javascript/controllers/better_ui/index.js`
   - Content: Export all controllers for eager loading

### Phase 4: Create Theme Generator
**Duration:** 3 hours
**Objective:** Create generator that installs theme in host applications

#### Tasks:

1. **Task 4.1:** Extract theme from Powerbankly
   - Description: Extract complete color system and typography from Powerbankly CSS
   - Assigned to: Developer
   - Dependencies: None
   - Deliverables: Complete theme documentation
   - Source files to analyze:
     - `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/app/assets/stylesheets/application.tailwind.css`
     - Look for @theme inline blocks and color definitions
   - Document all 9 variants with full scale (50-950)

2. **Task 4.2:** Create generator template
   - Description: Create ERB template for theme CSS file
   - Assigned to: Developer
   - Dependencies: Task 4.1
   - Deliverables: Theme template file
   - File to create: `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/lib/generators/better_ui/install/templates/better_ui_theme.css.tt`
   - Content: Complete @theme inline block with all color variants

3. **Task 4.3:** Create install generator
   - Description: Create Rails generator that installs theme in host apps
   - Assigned to: Developer
   - Dependencies: Task 4.2
   - Deliverables: Install generator class
   - File to create: `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/lib/generators/better_ui/install/install_generator.rb`
   - Functionality:
     - Copy theme template to host app
     - Update host app's CSS with @import and @source directives
     - Add vendor/bundle scanning directive

4. **Task 4.4:** Add helper method to main module
   - Description: Add template_paths helper for documentation
   - Assigned to: Developer
   - Dependencies: None
   - Deliverables: Updated BetterUi module
   - File to modify: `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/lib/better_ui.rb`
   - Add template_paths class method

### Phase 5: Setup Lookbook Previews
**Duration:** 3 hours
**Objective:** Create component previews for documentation

#### Tasks:

1. **Task 5.1:** Create ButtonComponent preview
   - Description: Create comprehensive button preview with all variants
   - Assigned to: Developer
   - Dependencies: Phase 2 complete
   - Deliverables: Button preview class
   - Source reference: `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/spec/components/previews/ui/button_component_preview.rb`
   - Target file: `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/spec/components/previews/better_ui/button_component_preview.rb`
   - Show all sizes, styles, variants, loading states

2. **Task 5.2:** Create CardComponent preview
   - Description: Create card preview with slot combinations
   - Assigned to: Developer
   - Dependencies: Phase 2 complete
   - Deliverables: Card preview class
   - Source reference: `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/spec/components/previews/ui/card_component_preview.rb`
   - Target file: `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/spec/components/previews/better_ui/card_component_preview.rb`

3. **Task 5.3:** Create ActionMessagesComponent preview
   - Description: Create action messages preview with all styles
   - Assigned to: Developer
   - Dependencies: Phase 2 complete
   - Deliverables: Action messages preview class
   - Source reference: `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/spec/components/previews/ui/action_messages_component_preview.rb`
   - Target file: `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/spec/components/previews/better_ui/action_messages_component_preview.rb`

4. **Task 5.4:** Create form component previews
   - Description: Create previews for all form components
   - Assigned to: Developer
   - Dependencies: Phase 2 complete
   - Deliverables: Form component preview classes
   - Files to create:
     - `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/spec/components/previews/better_ui/forms/text_input_component_preview.rb`
     - `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/spec/components/previews/better_ui/forms/number_input_component_preview.rb`
     - `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/spec/components/previews/better_ui/forms/password_input_component_preview.rb`
     - `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/spec/components/previews/better_ui/forms/textarea_component_preview.rb`

### Phase 6: Setup Dummy App
**Duration:** 4 hours
**Objective:** Configure dummy app with PostCSS/Tailwind for development

#### Tasks:

1. **Task 6.1:** Create demo controller
   - Description: Create controller for component demos
   - Assigned to: Developer
   - Dependencies: Phase 2 complete
   - Deliverables: Demo controller with actions
   - File to create: `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/test/dummy/app/controllers/better_ui/demos_controller.rb`
   - Actions: index, buttons, cards, alerts, forms

2. **Task 6.2:** Create demo views
   - Description: Create views showcasing all components
   - Assigned to: Developer
   - Dependencies: Task 6.1
   - Deliverables: Demo view files
   - Files to create:
     - `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/test/dummy/app/views/better_ui/demos/index.html.erb`
     - `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/test/dummy/app/views/better_ui/demos/buttons.html.erb`
     - `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/test/dummy/app/views/better_ui/demos/cards.html.erb`
     - `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/test/dummy/app/views/better_ui/demos/alerts.html.erb`
     - `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/test/dummy/app/views/better_ui/demos/forms.html.erb`

3. **Task 6.3:** Update dummy app routes
   - Description: Add routes for demo pages
   - Assigned to: Developer
   - Dependencies: Task 6.1
   - Deliverables: Updated routes file
   - File to modify: `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/test/dummy/config/routes.rb`

4. **Task 6.4:** Setup PostCSS/Tailwind build
   - Description: Configure dummy app with PostCSS and Tailwind v4
   - Assigned to: Developer
   - Dependencies: None
   - Deliverables: Complete CSS build setup
   - Files to create:
     - `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/test/dummy/package.json`
     - `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/test/dummy/postcss.config.mjs`
     - `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/test/dummy/app/assets/stylesheets/application.tailwind.css`
     - `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/test/dummy/Procfile.dev`
     - `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/test/dummy/bin/dev`

5. **Task 6.5:** Install theme in dummy app
   - Description: Run generator to install theme in dummy app
   - Assigned to: Developer
   - Dependencies: Phase 4 complete, Task 6.4
   - Deliverables: Theme installed in dummy app
   - Commands:
     ```bash
     cd /Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/test/dummy
     rails generate better_ui:install
     yarn install
     yarn build:css
     ```

6. **Task 6.6:** Update gitignore
   - Description: Add build artifacts to gitignore
   - Assigned to: Developer
   - Dependencies: None
   - Deliverables: Updated gitignore
   - File to modify: `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/.gitignore`
   - Add: node_modules, build outputs, lock files

### Phase 7: Documentation
**Duration:** 3 hours
**Objective:** Create comprehensive documentation

#### Tasks:

1. **Task 7.1:** Update README.md
   - Description: Add comprehensive README with usage instructions
   - Assigned to: Developer
   - Dependencies: All previous phases
   - Deliverables: Updated README
   - File to modify: `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/README.md`
   - Sections: CSS requirements, installation, quick start, components overview

2. **Task 7.2:** Create INSTALLATION.md
   - Description: Create detailed installation guide
   - Assigned to: Developer
   - Dependencies: Phase 4 complete
   - Deliverables: Installation documentation
   - File to create: `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/INSTALLATION.md`
   - Include: Prerequisites, step-by-step setup, troubleshooting

3. **Task 7.3:** Create COMPONENTS.md
   - Description: Document all components with examples
   - Assigned to: Developer
   - Dependencies: Phase 2 complete
   - Deliverables: Component documentation
   - File to create: `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/COMPONENTS.md`

4. **Task 7.4:** Create CUSTOMIZATION.md
   - Description: Document theming and customization options
   - Assigned to: Developer
   - Dependencies: Phase 4 complete
   - Deliverables: Customization guide
   - File to create: `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/CUSTOMIZATION.md`

### Phase 8: Testing and Validation
**Duration:** 2 hours
**Objective:** Ensure all components work correctly

#### Tasks:

1. **Task 8.1:** Create component tests
   - Description: Write basic rendering tests for all components
   - Assigned to: Developer
   - Dependencies: Phase 2 complete
   - Deliverables: Test files for components
   - Directory: `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/test/components/better_ui/`

2. **Task 8.2:** Test form builder
   - Description: Create tests for UiFormBuilder
   - Assigned to: Developer
   - Dependencies: Task 2.10
   - Deliverables: Form builder test file
   - File to create: `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/test/form_builders/better_ui/ui_form_builder_test.rb`

3. **Task 8.3:** Visual validation
   - Description: Manually test all components in dummy app and Lookbook
   - Assigned to: Developer
   - Dependencies: Phases 5-6 complete
   - Deliverables: Confirmed working components
   - Test areas:
     - All component variants render correctly
     - Stimulus controllers function
     - Forms integrate properly
     - Colors and theming work

4. **Task 8.4:** Build and bundle validation
   - Description: Verify gem builds and installs correctly
   - Assigned to: Developer
   - Dependencies: All previous phases
   - Deliverables: Working gem bundle
   - Commands:
     ```bash
     cd /Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui
     bundle install
     bundle exec rake test
     gem build better_ui.gemspec
     ```

## Success Criteria

1. **All 10 Ruby components migrated** with correct namespacing
2. **All 7 ERB templates migrated** with updated controller references
3. **All 3 Stimulus controllers migrated** with new naming convention
4. **Theme generator works** and creates proper files in host apps
5. **Lookbook previews display** all component variants
6. **Dummy app runs** with working PostCSS/Tailwind build
7. **Documentation is complete** and accurate
8. **Tests pass** for all components
9. **Gem builds successfully** without warnings
10. **Components render correctly** with all styles applied

## Risk Mitigation

### Risk: Namespace conflicts
**Mitigation:** Carefully update all references when changing from Ui:: to BetterUi::

### Risk: Stimulus controller naming issues
**Mitigation:** Test each controller thoroughly after renaming, update all data-controller attributes

### Risk: CSS not loading in dummy app
**Mitigation:** Verify PostCSS configuration, check @source paths, ensure yarn build:css runs

### Risk: Missing Tailwind classes
**Mitigation:** Ensure @source directive scans all component files, check for dynamic class construction

### Risk: Generator fails in host apps
**Mitigation:** Test generator in clean Rails app, handle edge cases like missing files

## Execution Notes

- Start with Phase 1-2 to establish core components
- Phase 3-4 can be done in parallel with Phase 5
- Phase 6 requires Phases 2 and 4 to be complete
- Documentation (Phase 7) can be started early and refined throughout
- Testing (Phase 8) should be ongoing but final validation at end

## File Path Reference

All file paths are absolute for clarity. The main directories are:
- **Gem root:** `/Users/umberto/Documents/Work/pandev/github/umbertopeserico/better_ui/better_ui/`
- **Source (Powerbankly):** `/Users/umberto/Documents/Work/pandev/powerbankly/powerbankly/`

Components will be placed in standard Rails engine locations within the gem.