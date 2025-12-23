# frozen_string_literal: true

module BetterUi
  # Custom Rails form builder for rendering form inputs using BetterUi::Forms components.
  #
  # This form builder integrates seamlessly with ActiveModel objects to automatically
  # populate field values, validation errors, and required status from the model.
  # All form inputs are rendered using ViewComponents from the BetterUi::Forms namespace,
  # ensuring consistent styling and behavior across the application.
  #
  # @example Basic usage with form_with
  #   <%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  #     <%= f.bui_text_input :name %>
  #     <%= f.bui_text_input :email, hint: "We'll never share your email" %>
  #     <%= f.bui_number_input :age, min: 0, max: 120 %>
  #   <% end %>
  #
  # @example With custom labels and sizes
  #   <%= form_with model: @product, builder: BetterUi::UiFormBuilder do |f| %>
  #     <%= f.bui_text_input :title, label: "Product Name", size: :lg %>
  #     <%= f.bui_number_input :price, label: "Price ($)", min: 0, step: 0.01 %>
  #   <% end %>
  #
  # @example With icon slots
  #   <%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  #     <%= f.bui_text_input :email do |component| %>
  #       <% component.with_prefix_icon do %>
  #         <svg class="h-5 w-5 text-gray-400">...</svg>
  #       <% end %>
  #     <% end %>
  #
  #     <%= f.bui_number_input :budget do |component| %>
  #       <% component.with_prefix_icon { "$" } %>
  #     <% end %>
  #   <% end %>
  #
  # @example Automatic error handling
  #   # When @user has validation errors:
  #   <%= form_with model: @user, builder: BetterUi::UiFormBuilder do |f| %>
  #     <%= f.bui_text_input :email %>
  #     # Automatically displays error messages and applies error styling
  #   <% end %>
  #
  # @see BetterUi::Forms::TextInputComponent
  # @see BetterUi::Forms::NumberInputComponent
  # @see BetterUi::Forms::PasswordInputComponent
  # @see BetterUi::Forms::TextareaComponent
  # @see BetterUi::Forms::BaseComponent
  class UiFormBuilder < ActionView::Helpers::FormBuilder
    # Renders a text input field using BetterUi::Forms::TextInputComponent
    #
    # @param attribute [Symbol] The attribute name
    # @param options [Hash] Additional options to pass to the component
    # @option options [String] :label Custom label text (defaults to humanized attribute name)
    # @option options [String] :hint Hint text to display below the input
    # @option options [String] :placeholder Placeholder text
    # @option options [Symbol] :size Size variant (:xs, :sm, :md, :lg, :xl)
    # @option options [Boolean] :disabled Whether the input is disabled
    # @option options [Boolean] :readonly Whether the input is readonly
    # @option options [Boolean] :required Whether the input is required
    # @return [String] Rendered component HTML
    #
    # @example Basic usage
    #   <%= f.bui_text_input :email %>
    #
    # @example With options
    #   <%= f.bui_text_input :email, size: :lg, hint: "We'll never share your email" %>
    #
    # @example With icon
    #   <%= f.bui_text_input :email do |c| %>
    #     <% c.with_prefix_icon { "📧" } %>
    #   <% end %>
    def bui_text_input(attribute, options = {}, &block)
      component_options = build_input_options(attribute, options)

      if block_given?
        @template.render(BetterUi::Forms::TextInputComponent.new(**component_options), &block)
      else
        @template.render(BetterUi::Forms::TextInputComponent.new(**component_options))
      end
    end

    # Renders a number input field using BetterUi::Forms::NumberInputComponent
    #
    # @param attribute [Symbol] The attribute name
    # @param options [Hash] Additional options to pass to the component
    # @option options [String] :label Custom label text (defaults to humanized attribute name)
    # @option options [String] :hint Hint text to display below the input
    # @option options [String] :placeholder Placeholder text
    # @option options [Symbol] :size Size variant (:xs, :sm, :md, :lg, :xl)
    # @option options [Boolean] :disabled Whether the input is disabled
    # @option options [Boolean] :readonly Whether the input is readonly
    # @option options [Boolean] :required Whether the input is required
    # @option options [Numeric] :min Minimum value
    # @option options [Numeric] :max Maximum value
    # @option options [Numeric] :step Step value
    # @option options [Boolean] :show_spinner Whether to show up/down spinner arrows (default: true)
    # @return [String] Rendered component HTML
    #
    # @example Basic usage
    #   <%= f.bui_number_input :age %>
    #
    # @example With range and step
    #   <%= f.bui_number_input :price, min: 0, max: 10000, step: 0.01 %>
    #
    # @example Without spinners
    #   <%= f.bui_number_input :price, show_spinner: false %>
    #
    # @example With icon
    #   <%= f.bui_number_input :price do |c| %>
    #     <% c.with_prefix_icon { "$" } %>
    #   <% end %>
    def bui_number_input(attribute, options = {}, &block)
      component_options = build_input_options(attribute, options)

      # Add number-specific options
      component_options[:min] = options[:min] if options.key?(:min)
      component_options[:max] = options[:max] if options.key?(:max)
      component_options[:step] = options[:step] if options.key?(:step)
      component_options[:show_spinner] = options.fetch(:show_spinner, true)

      if block_given?
        @template.render(BetterUi::Forms::NumberInputComponent.new(**component_options), &block)
      else
        @template.render(BetterUi::Forms::NumberInputComponent.new(**component_options))
      end
    end

    # Renders a password input field using BetterUi::Forms::PasswordInputComponent
    #
    # @param attribute [Symbol] The attribute name
    # @param options [Hash] Additional options to pass to the component
    # @option options [String] :label Custom label text (defaults to humanized attribute name)
    # @option options [String] :hint Hint text to display below the input
    # @option options [String] :placeholder Placeholder text
    # @option options [Symbol] :size Size variant (:xs, :sm, :md, :lg, :xl)
    # @option options [Boolean] :disabled Whether the input is disabled
    # @option options [Boolean] :readonly Whether the input is readonly
    # @option options [Boolean] :required Whether the input is required
    # @return [String] Rendered component HTML
    #
    # @example Basic usage
    #   <%= f.bui_password_input :password %>
    #
    # @example With confirmation field
    #   <%= f.bui_password_input :password, hint: "Must be at least 8 characters" %>
    #   <%= f.bui_password_input :password_confirmation %>
    #
    # @example With icon
    #   <%= f.bui_password_input :password do |c| %>
    #     <% c.with_prefix_icon do %>
    #       <svg class="h-5 w-5 text-gray-400">...</svg>
    #     <% end %>
    #   <% end %>
    def bui_password_input(attribute, options = {}, &block)
      component_options = build_input_options(attribute, options)

      if block_given?
        @template.render(BetterUi::Forms::PasswordInputComponent.new(**component_options), &block)
      else
        @template.render(BetterUi::Forms::PasswordInputComponent.new(**component_options))
      end
    end

    # Renders a textarea field using BetterUi::Forms::TextareaComponent
    #
    # @param attribute [Symbol] The attribute name
    # @param options [Hash] Additional options to pass to the component
    # @option options [String] :label Custom label text (defaults to humanized attribute name)
    # @option options [String] :hint Hint text to display below the textarea
    # @option options [String] :placeholder Placeholder text
    # @option options [Symbol] :size Size variant (:xs, :sm, :md, :lg, :xl)
    # @option options [Boolean] :disabled Whether the textarea is disabled
    # @option options [Boolean] :readonly Whether the textarea is readonly
    # @option options [Boolean] :required Whether the textarea is required
    # @option options [Integer] :rows Number of visible text lines (default: 4)
    # @option options [Integer] :cols Width in characters (optional)
    # @option options [Integer] :maxlength Maximum number of characters allowed
    # @option options [Symbol] :resize CSS resize behavior (:none, :vertical, :horizontal, :both)
    # @return [String] Rendered component HTML
    #
    # @example Basic usage
    #   <%= f.bui_textarea :description %>
    #
    # @example With custom rows and maxlength
    #   <%= f.bui_textarea :bio, rows: 6, maxlength: 500, hint: "Maximum 500 characters" %>
    #
    # @example With resize disabled
    #   <%= f.bui_textarea :notes, resize: :none %>
    #
    # @example With icon
    #   <%= f.bui_textarea :comment do |c| %>
    #     <% c.with_prefix_icon do %>
    #       <svg class="h-5 w-5 text-gray-400">...</svg>
    #     <% end %>
    #   <% end %>
    def bui_textarea(attribute, options = {}, &block)
      component_options = build_input_options(attribute, options)

      # Add textarea-specific options
      component_options[:rows] = options.fetch(:rows, 4)
      component_options[:cols] = options[:cols] if options.key?(:cols)
      component_options[:maxlength] = options[:maxlength] if options.key?(:maxlength)
      component_options[:resize] = options.fetch(:resize, :vertical)

      if block_given?
        @template.render(BetterUi::Forms::TextareaComponent.new(**component_options), &block)
      else
        @template.render(BetterUi::Forms::TextareaComponent.new(**component_options))
      end
    end

    # Renders a checkbox input field using BetterUi::Forms::CheckboxComponent
    #
    # @param attribute [Symbol] The attribute name
    # @param options [Hash] Additional options to pass to the component
    # @option options [String] :label Custom label text (defaults to humanized attribute name)
    # @option options [String] :value The value submitted when checkbox is checked (default: "1")
    # @option options [String] :hint Hint text to display below the checkbox
    # @option options [Symbol] :variant Color variant (:primary, :secondary, :accent, :success, :danger, :warning, :info, :light, :dark)
    # @option options [Symbol] :size Size variant (:xs, :sm, :md, :lg, :xl)
    # @option options [Symbol] :label_position Position of label relative to checkbox (:left, :right)
    # @option options [Boolean] :disabled Whether the checkbox is disabled
    # @option options [Boolean] :readonly Whether the checkbox is readonly
    # @option options [Boolean] :required Whether the checkbox is required
    # @return [String] Rendered component HTML
    #
    # @example Basic usage
    #   <%= f.bui_checkbox :newsletter %>
    #
    # @example With custom label
    #   <%= f.bui_checkbox :terms, label: "I agree to the terms and conditions" %>
    #
    # @example With variant
    #   <%= f.bui_checkbox :active, variant: :success, label: "Active" %>
    def bui_checkbox(attribute, options = {})
      component_options = build_checkbox_options(attribute, options)

      @template.render(BetterUi::Forms::CheckboxComponent.new(**component_options))
    end

    # Renders a checkbox group using BetterUi::Forms::CheckboxGroupComponent
    #
    # @param attribute [Symbol] The attribute name
    # @param collection [Array] The collection of options, can be:
    #   - Array of values (e.g., ["Admin", "Editor"])
    #   - Array of [label, value] pairs (e.g., [["Admin", "admin"], ["Editor", "editor"]])
    # @param options [Hash] Additional options to pass to the component
    # @option options [String] :legend Legend text for the fieldset (defaults to humanized attribute name)
    # @option options [String] :hint Hint text to display below the checkboxes
    # @option options [Symbol] :variant Color variant for all checkboxes (:primary, :secondary, etc.)
    # @option options [Symbol] :size Size variant (:xs, :sm, :md, :lg, :xl)
    # @option options [Symbol] :orientation Layout orientation (:vertical, :horizontal)
    # @option options [Boolean] :disabled Whether all checkboxes are disabled
    # @option options [Boolean] :required Whether the field is required
    # @return [String] Rendered component HTML
    #
    # @example Basic usage
    #   <%= f.bui_checkbox_group :roles, ["Admin", "Editor", "Viewer"] %>
    #
    # @example With label/value pairs
    #   <%= f.bui_checkbox_group :permissions, [["Read", "read"], ["Write", "write"]] %>
    #
    # @example Horizontal layout
    #   <%= f.bui_checkbox_group :interests, ["Sports", "Music", "Art"], orientation: :horizontal %>
    def bui_checkbox_group(attribute, collection, options = {})
      component_options = build_checkbox_group_options(attribute, collection, options)

      @template.render(BetterUi::Forms::CheckboxGroupComponent.new(**component_options))
    end

    private

    # Builds common options for input components.
    #
    # Extracts and merges options from the form model, user-provided options,
    # and default values. Automatically populates field name, value, errors,
    # and required status from the ActiveModel object.
    #
    # @param attribute [Symbol] the attribute name
    # @param options [Hash] user-provided options to override defaults
    # @return [Hash] complete hash of component options ready for rendering
    # @api private
    def build_input_options(attribute, options)
      {
        name: field_name(attribute),
        value: object_value(attribute),
        label: options.fetch(:label, attribute.to_s.humanize),
        hint: options[:hint],
        placeholder: options[:placeholder],
        size: options.fetch(:size, :md),
        disabled: options.fetch(:disabled, false),
        readonly: options.fetch(:readonly, false),
        required: options.fetch(:required, field_required?(attribute)),
        errors: object_errors(attribute),
        container_classes: options[:container_classes],
        label_classes: options[:label_classes],
        input_classes: options[:input_classes],
        hint_classes: options[:hint_classes],
        error_classes: options[:error_classes]
      }.merge(extract_html_attributes(options))
    end

    # Gets the value of an attribute from the object.
    #
    # Safely retrieves the attribute value from the form's model object,
    # returning nil if the object doesn't respond to the attribute method.
    #
    # @param attribute [Symbol] the attribute name
    # @return [Object, nil] the attribute value, or nil if not accessible
    # @api private
    def object_value(attribute)
      @object&.public_send(attribute)
    rescue NoMethodError
      nil
    end

    # Gets validation errors for an attribute.
    #
    # Retrieves full error messages for the specified attribute from the
    # model's errors object. Returns empty array if model doesn't support errors.
    #
    # @param attribute [Symbol] the attribute name
    # @return [Array<String>] array of full error messages for the attribute
    # @api private
    def object_errors(attribute)
      return [] unless @object&.respond_to?(:errors)

      @object.errors.full_messages_for(attribute)
    end

    # Determines if a field is required based on model validations.
    #
    # Inspects the model's validators to detect presence validators on the
    # specified attribute. Returns true if a PresenceValidator is found.
    #
    # @param attribute [Symbol] the attribute name
    # @return [Boolean] true if the field has a presence validator, false otherwise
    # @api private
    def field_required?(attribute)
      return false unless @object.class.respond_to?(:validators_on)

      validators = @object.class.validators_on(attribute)
      validators.any? { |v| v.is_a?(ActiveModel::Validations::PresenceValidator) }
    rescue NoMethodError
      false
    end

    # Extracts HTML attributes from options.
    #
    # Filters user-provided options to extract standard HTML attributes
    # (id, class, data, aria, etc.) that should be passed through to the
    # input element.
    #
    # @param options [Hash] user-provided options
    # @return [Hash] hash of HTML attributes to pass through
    # @api private
    def extract_html_attributes(options)
      html_attrs = {}

      # Pass through common HTML attributes
      html_attrs[:id] = options[:id] if options.key?(:id)
      html_attrs[:class] = options[:class] if options.key?(:class)
      html_attrs[:data] = options[:data] if options.key?(:data)
      html_attrs[:aria] = options[:aria] if options.key?(:aria)
      html_attrs[:autocomplete] = options[:autocomplete] if options.key?(:autocomplete)
      html_attrs[:maxlength] = options[:maxlength] if options.key?(:maxlength)
      html_attrs[:pattern] = options[:pattern] if options.key?(:pattern)

      html_attrs
    end

    # Generates the field name for form submission.
    #
    # Creates the proper HTML name attribute for the input field, following
    # Rails conventions for nested attributes (e.g., "user[email]").
    # If no object_name is present, returns the attribute as a string.
    #
    # @param attribute [Symbol] the attribute name
    # @return [String] the properly formatted field name for form submission
    # @api private
    # @example With object name
    #   field_name(:email) # => "user[email]" (when object_name is "user")
    # @example Without object name
    #   field_name(:email) # => "email"
    def field_name(attribute)
      @object_name ? "#{@object_name}[#{attribute}]" : attribute.to_s
    end

    # Builds options for checkbox components.
    #
    # Creates the complete options hash for CheckboxComponent including
    # auto-populated values from the model for checked state and errors.
    #
    # @param attribute [Symbol] the attribute name
    # @param options [Hash] user-provided options to override defaults
    # @return [Hash] complete hash of component options ready for rendering
    # @api private
    def build_checkbox_options(attribute, options)
      {
        name: field_name(attribute),
        value: options.fetch(:value, "1"),
        checked: checkbox_checked?(attribute),
        label: options.fetch(:label, attribute.to_s.humanize),
        hint: options[:hint],
        variant: options.fetch(:variant, :primary),
        size: options.fetch(:size, :md),
        label_position: options.fetch(:label_position, :right),
        disabled: options.fetch(:disabled, false),
        readonly: options.fetch(:readonly, false),
        required: options.fetch(:required, field_required?(attribute)),
        errors: object_errors(attribute),
        container_classes: options[:container_classes],
        label_classes: options[:label_classes],
        checkbox_classes: options[:checkbox_classes],
        hint_classes: options[:hint_classes],
        error_classes: options[:error_classes]
      }.merge(extract_html_attributes(options))
    end

    # Builds options for checkbox group components.
    #
    # Creates the complete options hash for CheckboxGroupComponent including
    # auto-populated values from the model for selected values and errors.
    #
    # @param attribute [Symbol] the attribute name
    # @param collection [Array] the collection of options
    # @param options [Hash] user-provided options to override defaults
    # @return [Hash] complete hash of component options ready for rendering
    # @api private
    def build_checkbox_group_options(attribute, collection, options)
      {
        name: field_name(attribute),
        collection: collection,
        selected: Array(object_value(attribute)),
        legend: options.fetch(:legend, attribute.to_s.humanize),
        hint: options[:hint],
        variant: options.fetch(:variant, :primary),
        size: options.fetch(:size, :md),
        orientation: options.fetch(:orientation, :vertical),
        disabled: options.fetch(:disabled, false),
        required: options.fetch(:required, field_required?(attribute)),
        errors: object_errors(attribute),
        container_classes: options[:container_classes],
        legend_classes: options[:legend_classes],
        items_classes: options[:items_classes],
        hint_classes: options[:hint_classes],
        error_classes: options[:error_classes]
      }.merge(extract_html_attributes(options))
    end

    # Determines if a checkbox should be checked based on the model's attribute value.
    #
    # For boolean attributes, returns the boolean value.
    # For other types, checks if the value is present/truthy.
    #
    # @param attribute [Symbol] the attribute name
    # @return [Boolean] true if the checkbox should be checked, false otherwise
    # @api private
    def checkbox_checked?(attribute)
      value = object_value(attribute)
      return value if value.is_a?(TrueClass) || value.is_a?(FalseClass)

      value.present?
    end
  end
end
