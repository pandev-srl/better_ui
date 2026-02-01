# frozen_string_literal: true

module BetterUi
  module Breadcrumb
    # @label Breadcrumb
    class BreadcrumbComponentPreview < ViewComponent::Preview
      # @label Default
      def default
        render_with_template
      end

      # @label All Separators
      def all_separators
        render_with_template
      end

      # @label With Icons
      def with_icons
        render_with_template
      end

      # @label Playground
      # @param separator select { choices: [slash, chevron, dot] }
      # @param size select { choices: [sm, md, lg] }
      def playground(separator: :slash, size: :md)
        render BetterUi::Breadcrumb::BreadcrumbComponent.new(
          separator: separator.to_sym,
          size: size.to_sym
        ) do |breadcrumb|
          breadcrumb.with_item(label: "Home", href: "#")
          breadcrumb.with_item(label: "Library", href: "#")
          breadcrumb.with_item(label: "Articles", href: "#")
          breadcrumb.with_item(label: "Current Article")
        end
      end
    end
  end
end
