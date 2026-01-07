# frozen_string_literal: true

require "test_helper"

module BetterUi
  class ApplicationHelperTest < ActionView::TestCase
    include BetterUi::ApplicationHelper

    # ============================================
    # Core Components
    # ============================================

    # bui_button tests
    test "bui_button renders ButtonComponent" do
      output = bui_button(variant: :primary) { "Click me" }

      assert_match(/button/, output)
      assert_match(/Click me/, output)
    end

    test "bui_button accepts variant option" do
      output = bui_button(variant: :success) { "Save" }

      assert_match(/bg-success/, output)
    end

    test "bui_button accepts size option" do
      output = bui_button(size: :lg) { "Large" }

      assert_match(/text-lg/, output)
    end

    test "bui_button accepts type option" do
      output = bui_button(type: :submit) { "Submit" }

      assert_match(/type="submit"/, output)
    end

    # bui_card tests
    test "bui_card renders CardComponent" do
      output = bui_card(variant: :primary) do |card|
        card.with_body { "Content" }
      end

      assert_match(/Content/, output)
    end

    test "bui_card accepts variant option" do
      output = bui_card(variant: :success) do |card|
        card.with_body { "Body" }
      end

      assert_match(/success/, output)
    end

    test "bui_card renders header slot" do
      output = bui_card do |card|
        card.with_header { "Header" }
        card.with_body { "Body" }
      end

      assert_match(/Header/, output)
      assert_match(/Body/, output)
    end

    test "bui_card renders footer slot" do
      output = bui_card do |card|
        card.with_body { "Body" }
        card.with_footer { "Footer" }
      end

      assert_match(/Footer/, output)
    end

    # bui_action_messages tests
    test "bui_action_messages renders ActionMessagesComponent" do
      output = bui_action_messages([ "Success!" ], variant: :success)

      assert_match(/Success!/, output)
    end

    test "bui_action_messages accepts multiple messages" do
      output = bui_action_messages([ "Error 1", "Error 2" ], variant: :danger)

      assert_match(/Error 1/, output)
      assert_match(/Error 2/, output)
    end

    test "bui_action_messages accepts title option" do
      output = bui_action_messages([ "Message" ], title: "Alert Title")

      assert_match(/Alert Title/, output)
    end

    test "bui_action_messages accepts dismissible option" do
      output = bui_action_messages([ "Message" ], dismissible: true)

      assert_match(/button/, output) # dismiss button
    end

    # ============================================
    # Form Components
    # ============================================

    # bui_text_input tests
    test "bui_text_input renders TextInputComponent" do
      output = bui_text_input("email")

      assert_match(/input/, output)
      assert_match(/type="text"/, output)
      assert_match(/name="email"/, output)
    end

    test "bui_text_input accepts label option" do
      output = bui_text_input("email", label: "Email Address")

      assert_match(/Email Address/, output)
    end

    test "bui_text_input accepts placeholder option" do
      output = bui_text_input("email", placeholder: "you@example.com")

      assert_match(/placeholder="you@example.com"/, output)
    end

    test "bui_text_input accepts value option" do
      output = bui_text_input("email", value: "test@example.com")

      assert_match(/value="test@example.com"/, output)
    end

    test "bui_text_input accepts block for slots" do
      output = bui_text_input("search") do |input|
        input.with_prefix_icon { '<span class="icon">🔍</span>'.html_safe }
      end

      assert_match(/icon/, output)
    end

    # bui_number_input tests
    test "bui_number_input renders NumberInputComponent" do
      output = bui_number_input("quantity")

      assert_match(/input/, output)
      assert_match(/type="number"/, output)
      assert_match(/name="quantity"/, output)
    end

    test "bui_number_input accepts min and max options" do
      output = bui_number_input("age", min: 0, max: 120)

      assert_match(/min="0"/, output)
      assert_match(/max="120"/, output)
    end

    test "bui_number_input accepts step option" do
      output = bui_number_input("price", step: 0.01)

      assert_match(/step="0.01"/, output)
    end

    # bui_password_input tests
    test "bui_password_input renders PasswordInputComponent" do
      output = bui_password_input("password")

      assert_match(/input/, output)
      assert_match(/type="password"/, output)
      assert_match(/name="password"/, output)
    end

    test "bui_password_input includes visibility toggle" do
      output = bui_password_input("password")

      assert_match(/data-controller="better-ui--forms--password-input"/, output)
      assert_match(/button/, output) # toggle button
    end

    # bui_textarea tests
    test "bui_textarea renders TextareaComponent" do
      output = bui_textarea("description")

      assert_match(/textarea/, output)
      assert_match(/name="description"/, output)
    end

    test "bui_textarea accepts rows option" do
      output = bui_textarea("bio", rows: 8)

      assert_match(/rows="8"/, output)
    end

    test "bui_textarea accepts maxlength option" do
      output = bui_textarea("bio", maxlength: 500)

      assert_match(/maxlength="500"/, output)
    end

    # ============================================
    # Drawer Components
    # ============================================

    # bui_drawer_layout tests
    test "bui_drawer_layout renders LayoutComponent" do
      output = bui_drawer_layout do |layout|
        layout.with_main { "Main content" }
      end

      assert_match(/Main content/, output)
      assert_match(/data-controller="better-ui--drawer--layout"/, output)
    end

    test "bui_drawer_layout accepts sidebar_position option" do
      output = bui_drawer_layout(sidebar_position: :right) do |layout|
        layout.with_main { "Content" }
      end

      assert_match(/data-better-ui--drawer--layout-position-value="right"/, output)
    end

    # bui_drawer_sidebar tests
    test "bui_drawer_sidebar renders SidebarComponent" do
      output = bui_drawer_sidebar(variant: :dark) do |sidebar|
        sidebar.with_navigation { "Nav" }
      end

      assert_match(/Nav/, output)
    end

    test "bui_drawer_sidebar accepts variant option" do
      output = bui_drawer_sidebar(variant: :primary) do |sidebar|
        sidebar.with_navigation { "Nav" }
      end

      assert_match(/bg-primary/, output)
    end

    # bui_drawer_header tests
    test "bui_drawer_header renders HeaderComponent" do
      output = bui_drawer_header do |header|
        header.with_logo { "Logo" }
      end

      assert_match(/Logo/, output)
    end

    test "bui_drawer_header accepts variant option" do
      output = bui_drawer_header(variant: :dark) do |header|
        header.with_logo { "Logo" }
      end

      assert_match(/bg-grayscale-900/, output)
    end

    # bui_drawer_nav_item tests
    test "bui_drawer_nav_item renders NavItemComponent" do
      output = bui_drawer_nav_item("Dashboard", "/dashboard")

      assert_match(/Dashboard/, output)
      assert_match(/href="\/dashboard"/, output)
    end

    test "bui_drawer_nav_item accepts active option" do
      output = bui_drawer_nav_item("Home", "/", active: true)

      assert_match(/bg-/, output) # active background
    end

    test "bui_drawer_nav_item accepts block for icon slot" do
      output = bui_drawer_nav_item("Settings", "/settings") do |item|
        item.with_icon { '<svg class="nav-icon"></svg>'.html_safe }
      end

      assert_match(/nav-icon/, output)
    end

    # bui_drawer_nav_group tests
    test "bui_drawer_nav_group renders NavGroupComponent" do
      output = bui_drawer_nav_group(title: "Main Menu") do |group|
        group.with_item(label: "Home", href: "/")
      end

      assert_match(/Main Menu/, output)
      assert_match(/Home/, output)
    end

    test "bui_drawer_nav_group renders multiple items" do
      output = bui_drawer_nav_group do |group|
        group.with_item(label: "Home", href: "/")
        group.with_item(label: "About", href: "/about")
      end

      assert_match(/Home/, output)
      assert_match(/About/, output)
    end
  end
end
