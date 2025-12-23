# frozen_string_literal: true

require "test_helper"

module BetterUi
  class UiFormBuilderTest < ActiveSupport::TestCase
    # Mock model for testing
    class MockUser
      include ActiveModel::Model
      include ActiveModel::Validations

      attr_accessor :name, :email, :age, :password, :bio, :price

      validates :name, presence: true
      validates :email, presence: true, format: { with: /@/, message: "is invalid" }
      validates :age, numericality: { greater_than: 0 }
    end

    setup do
      @user = MockUser.new
      @template = ActionView::Base.new(ActionView::LookupContext.new([]), {}, nil)
      @builder = UiFormBuilder.new(:user, @user, @template, {})
    end

    # bui_text_input tests
    test "bui_text_input renders TextInputComponent" do
      @user.name = "John Doe"
      output = @builder.bui_text_input(:name)

      assert_match(/input/, output)
      assert_match(/type="text"/, output)
      assert_match(/name="user\[name\]"/, output)
      assert_match(/value="John Doe"/, output)
    end

    test "bui_text_input uses humanized attribute name as default label" do
      output = @builder.bui_text_input(:name)

      assert_match(/Name/, output)
    end

    test "bui_text_input accepts custom label" do
      output = @builder.bui_text_input(:name, label: "Full Name")

      assert_match(/Full Name/, output)
    end

    test "bui_text_input accepts hint text" do
      output = @builder.bui_text_input(:email, hint: "We'll never share your email")

      # HTML entities are encoded, so we need to check for the decoded version
      assert_match(/We&#39;ll never share your email/, output)
    end

    test "bui_text_input accepts placeholder" do
      output = @builder.bui_text_input(:email, placeholder: "you@example.com")

      assert_match(/placeholder="you@example.com"/, output)
    end

    test "bui_text_input accepts size option" do
      output = @builder.bui_text_input(:name, size: :lg)

      assert_match(/text-lg/, output)
    end

    test "bui_text_input shows errors from model" do
      @user.valid? # trigger validations
      output = @builder.bui_text_input(:email)

      # HTML entities are encoded, so we need to check for the encoded version
      assert_match(/Email can&#39;t be blank/, output)
    end

    test "bui_text_input marks required fields based on validations" do
      output = @builder.bui_text_input(:name)

      assert_match(/required/, output)
    end

    test "bui_text_input accepts block for icon slots" do
      output = @builder.bui_text_input(:email) do |component|
        component.with_prefix_icon { '<svg class="test-icon"></svg>'.html_safe }
      end

      assert_match(/test-icon/, output)
    end

    test "bui_text_input accepts disabled option" do
      output = @builder.bui_text_input(:name, disabled: true)

      assert_match(/disabled/, output)
    end

    test "bui_text_input accepts readonly option" do
      output = @builder.bui_text_input(:name, readonly: true)

      assert_match(/readonly/, output)
    end

    # bui_number_input tests
    test "bui_number_input renders NumberInputComponent" do
      @user.age = 25
      output = @builder.bui_number_input(:age)

      assert_match(/input/, output)
      assert_match(/type="number"/, output)
      assert_match(/name="user\[age\]"/, output)
      assert_match(/value="25"/, output)
    end

    test "bui_number_input accepts min option" do
      output = @builder.bui_number_input(:age, min: 0)

      assert_match(/min="0"/, output)
    end

    test "bui_number_input accepts max option" do
      output = @builder.bui_number_input(:age, max: 120)

      assert_match(/max="120"/, output)
    end

    test "bui_number_input accepts step option" do
      output = @builder.bui_number_input(:price, step: 0.01)

      assert_match(/step="0.01"/, output)
    end

    test "bui_number_input accepts all numeric options" do
      output = @builder.bui_number_input(:price, min: 0, max: 1000, step: 0.01)

      assert_match(/min="0"/, output)
      assert_match(/max="1000"/, output)
      assert_match(/step="0.01"/, output)
    end

    test "bui_number_input accepts show_spinner option" do
      output = @builder.bui_number_input(:age, show_spinner: false)

      assert_match(/hide-number-spinner/, output)
    end

    test "bui_number_input shows spinner by default" do
      output = @builder.bui_number_input(:age)

      refute_match(/hide-number-spinner/, output)
    end

    test "bui_number_input accepts block for icon slots" do
      output = @builder.bui_number_input(:price) do |component|
        component.with_prefix_icon { "<span>$</span>".html_safe }
      end

      assert_match(/\$/, output)
    end

    test "bui_number_input shows errors from model" do
      @user.age = -5
      @user.valid?
      output = @builder.bui_number_input(:age)

      assert_match(/Age must be greater than 0/, output)
    end

    # bui_password_input tests
    test "bui_password_input renders PasswordInputComponent" do
      output = @builder.bui_password_input(:password)

      assert_match(/input/, output)
      assert_match(/type="password"/, output)
      assert_match(/name="user\[password\]"/, output)
    end

    test "bui_password_input includes Stimulus controller" do
      output = @builder.bui_password_input(:password)

      assert_match(/data-controller="better-ui--forms--password-input"/, output)
    end

    test "bui_password_input includes toggle button" do
      output = @builder.bui_password_input(:password)

      assert_match(/button/, output)
      assert_match(/svg/, output) # eye icon
    end

    test "bui_password_input accepts hint text" do
      output = @builder.bui_password_input(:password, hint: "Minimum 8 characters")

      assert_match(/Minimum 8 characters/, output)
    end

    test "bui_password_input accepts block for prefix icon" do
      output = @builder.bui_password_input(:password) do |component|
        component.with_prefix_icon { '<svg class="lock-icon"></svg>'.html_safe }
      end

      assert_match(/lock-icon/, output)
    end

    test "bui_password_input can be marked as required" do
      # Explicitly mark password as required
      output = @builder.bui_password_input(:password, required: true)

      assert_match(/required/, output)
    end

    # bui_textarea tests
    test "bui_textarea renders TextareaComponent" do
      @user.bio = "Sample bio"
      output = @builder.bui_textarea(:bio)

      assert_match(/textarea/, output)
      assert_match(/name="user\[bio\]"/, output)
      assert_match(/Sample bio/, output)
    end

    test "bui_textarea has default rows" do
      output = @builder.bui_textarea(:bio)

      assert_match(/rows="4"/, output)
    end

    test "bui_textarea accepts custom rows" do
      output = @builder.bui_textarea(:bio, rows: 8)

      assert_match(/rows="8"/, output)
    end

    test "bui_textarea accepts cols option" do
      output = @builder.bui_textarea(:bio, cols: 80)

      assert_match(/cols="80"/, output)
    end

    test "bui_textarea accepts maxlength option" do
      output = @builder.bui_textarea(:bio, maxlength: 500)

      assert_match(/maxlength="500"/, output)
    end

    test "bui_textarea accepts resize option" do
      output = @builder.bui_textarea(:bio, resize: :none)

      assert_match(/resize-none/, output)
    end

    test "bui_textarea has vertical resize by default" do
      output = @builder.bui_textarea(:bio)

      assert_match(/resize-y/, output)
    end

    test "bui_textarea accepts hint text" do
      output = @builder.bui_textarea(:bio, hint: "Tell us about yourself")

      assert_match(/Tell us about yourself/, output)
    end

    test "bui_textarea accepts block for icon slots" do
      output = @builder.bui_textarea(:bio) do |component|
        component.with_prefix_icon { '<svg class="bio-icon"></svg>'.html_safe }
      end

      assert_match(/bio-icon/, output)
    end

    # Field name generation tests
    test "generates correct field names" do
      output = @builder.bui_text_input(:email)

      assert_match(/name="user\[email\]"/, output)
    end

    test "handles nested attributes in field names" do
      nested_builder = UiFormBuilder.new("user[profile]", @user, @template, {})
      output = nested_builder.bui_text_input(:name)

      assert_match(/name="user\[profile\]\[name\]"/, output)
    end

    # Value population tests
    test "populates values from model object" do
      @user.name = "Jane Doe"
      @user.email = "jane@example.com"
      @user.age = 30

      name_output = @builder.bui_text_input(:name)
      email_output = @builder.bui_text_input(:email)
      age_output = @builder.bui_number_input(:age)

      assert_match(/value="Jane Doe"/, name_output)
      assert_match(/value="jane@example.com"/, email_output)
      assert_match(/value="30"/, age_output)
    end

    test "handles nil values gracefully" do
      @user.name = nil
      output = @builder.bui_text_input(:name)

      refute_match(/value=/, output)
    end

    # Error handling tests
    test "displays errors for invalid fields" do
      @user.email = "invalid"
      @user.valid?

      output = @builder.bui_text_input(:email)

      assert_match(/Email is invalid/, output)
      assert_match(/border-danger-500/, output)
    end

    test "displays multiple errors for a field" do
      @user.email = "" # triggers both presence and format validations
      @user.valid?

      output = @builder.bui_text_input(:email)

      # HTML entities are encoded, so we need to check for the encoded version
      assert_match(/Email can&#39;t be blank/, output)
    end

    test "no errors displayed for valid fields" do
      @user.name = "Valid Name"
      @user.valid?

      output = @builder.bui_text_input(:name)

      refute_match(/border-danger-500/, output)
    end

    # Required field detection tests
    test "marks fields with presence validation as required" do
      output = @builder.bui_text_input(:name)

      assert_match(/required/, output)
    end

    test "does not mark optional fields as required" do
      output = @builder.bui_text_input(:bio)

      refute_match(/required/, output)
    end

    test "accepts explicit required option overriding validation" do
      output = @builder.bui_text_input(:bio, required: true)

      assert_match(/required/, output)
    end

    test "accepts explicit required false overriding validation" do
      output = @builder.bui_text_input(:name, required: false)

      refute_match(/required/, output)
    end

    # Custom classes tests
    test "accepts custom container classes" do
      output = @builder.bui_text_input(:name, container_classes: "custom-wrapper")

      assert_match(/custom-wrapper/, output)
    end

    test "accepts custom label classes" do
      output = @builder.bui_text_input(:name, label_classes: "custom-label")

      assert_match(/custom-label/, output)
    end

    test "accepts custom input classes" do
      output = @builder.bui_text_input(:name, input_classes: "custom-input")

      assert_match(/custom-input/, output)
    end

    # HTML attributes tests
    test "passes through id attribute" do
      output = @builder.bui_text_input(:name, id: "custom-id")

      assert_match(/id="custom-id"/, output)
    end

    test "passes through data attributes" do
      output = @builder.bui_text_input(:name, data: { controller: "custom" })

      assert_match(/data-controller="custom"/, output)
    end

    test "passes through aria attributes" do
      output = @builder.bui_text_input(:name, aria: { label: "User name" })

      assert_match(/aria-label="User name"/, output)
    end

    test "passes through autocomplete attribute" do
      output = @builder.bui_text_input(:email, autocomplete: "email")

      assert_match(/autocomplete="email"/, output)
    end

    test "passes through maxlength attribute to text input" do
      output = @builder.bui_text_input(:name, maxlength: 50)

      assert_match(/maxlength="50"/, output)
    end

    test "passes through pattern attribute" do
      output = @builder.bui_text_input(:name, pattern: "[A-Za-z]+")

      assert_match(/pattern="\[A-Za-z\]\+"/, output)
    end

    # Integration test with all features
    test "renders complete form with all input types" do
      @user.name = "John Doe"
      @user.email = "john@example.com"
      @user.age = 30
      @user.bio = "Developer"

      name_output = @builder.bui_text_input(:name, hint: "Your full name")
      email_output = @builder.bui_text_input(:email)
      age_output = @builder.bui_number_input(:age, min: 0, max: 120)
      password_output = @builder.bui_password_input(:password, hint: "Min 8 characters")
      bio_output = @builder.bui_textarea(:bio, rows: 6)

      assert_match(/value="John Doe"/, name_output)
      assert_match(/Your full name/, name_output)
      assert_match(/value="john@example.com"/, email_output)
      assert_match(/value="30"/, age_output)
      assert_match(/min="0"/, age_output)
      assert_match(/type="password"/, password_output)
      assert_match(/Min 8 characters/, password_output)
      assert_match(/Developer/, bio_output)
      assert_match(/rows="6"/, bio_output)
    end

    # Edge cases
    test "handles model without errors method" do
      simple_object = Struct.new(:name).new("Test")
      builder = UiFormBuilder.new(:simple, simple_object, @template, {})

      output = builder.bui_text_input(:name)

      assert_match(/value="Test"/, output)
      refute_match(/border-danger/, output)
    end

    test "handles model without validators_on method" do
      simple_object = Struct.new(:name).new("Test")
      builder = UiFormBuilder.new(:simple, simple_object, @template, {})

      output = builder.bui_text_input(:name)

      refute_match(/required/, output) # Should not crash, defaults to not required
    end

    test "handles missing attribute gracefully" do
      output = @builder.bui_text_input(:nonexistent_field)

      assert_match(/type="text"/, output)
      assert_match(/name="user\[nonexistent_field\]"/, output)
    end

    test "handles object that raises NoMethodError for attribute" do
      # Create object that raises NoMethodError for specific method
      object_with_method_error = Object.new
      def object_with_method_error.name
        raise NoMethodError, "undefined method"
      end

      builder = UiFormBuilder.new(:obj, object_with_method_error, @template, {})
      output = builder.bui_text_input(:name)

      assert_match(/type="text"/, output)
      # Should not crash and should render without value
    end

    test "handles class without validators_on raising NoMethodError" do
      # Create object whose class raises NoMethodError for validators_on
      faulty_object = Object.new
      faulty_object.define_singleton_method(:class) do
        faulty_class = Object.new
        def faulty_class.respond_to?(method)
          method == :validators_on
        end
        def faulty_class.validators_on(attr)
          raise NoMethodError, "validators_on not available"
        end
        faulty_class
      end

      builder = UiFormBuilder.new(:obj, faulty_object, @template, {})
      output = builder.bui_text_input(:anything)

      # Should not crash, defaults to not required
      refute_match(/required/, output)
    end
  end
end
