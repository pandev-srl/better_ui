# frozen_string_literal: true

module BetterUi
  module Table
    module Concerns
      # Shared SVG sort icon helpers for table header components.
      #
      # Provides three icon methods used by both TableComponent (collection mode)
      # and HeaderCellComponent (slot mode) to render sort direction indicators.
      module SortIcons
        extend ActiveSupport::Concern

        private

        # SVG chevron-up icon for ascending sort
        def sort_icon_asc_svg
          '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="currentColor" class="size-4">' \
            '<path fill-rule="evenodd" d="M11.78 9.78a.75.75 0 0 1-1.06 0L8 7.06 5.28 9.78a.75.75 0 0 1-1.06-1.06l3.25-3.25a.75.75 0 0 1 1.06 0l3.25 3.25a.75.75 0 0 1 0 1.06Z" clip-rule="evenodd" />' \
          "</svg>"
        end

        # SVG chevron-down icon for descending sort
        def sort_icon_desc_svg
          '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="currentColor" class="size-4">' \
            '<path fill-rule="evenodd" d="M4.22 6.22a.75.75 0 0 1 1.06 0L8 8.94l2.72-2.72a.75.75 0 1 1 1.06 1.06l-3.25 3.25a.75.75 0 0 1-1.06 0L4.22 7.28a.75.75 0 0 1 0-1.06Z" clip-rule="evenodd" />' \
          "</svg>"
        end

        # SVG chevron-up-down icon for unsorted state
        def sort_icon_unsorted_svg
          '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="currentColor" class="size-4">' \
            '<path fill-rule="evenodd" d="M5.22 10.22a.75.75 0 0 1 1.06 0L8 11.94l1.72-1.72a.75.75 0 1 1 1.06 1.06l-2.25 2.25a.75.75 0 0 1-1.06 0l-2.25-2.25a.75.75 0 0 1 0-1.06ZM10.78 5.78a.75.75 0 0 1-1.06 0L8 4.06 6.28 5.78a.75.75 0 0 1-1.06-1.06l2.25-2.25a.75.75 0 0 1 1.06 0l2.25 2.25a.75.75 0 0 1 0 1.06Z" clip-rule="evenodd" />' \
          "</svg>"
        end

        # Returns the appropriate sort icon SVG for the given sort state
        def sort_icon_svg(sorted:, direction: :asc)
          return sort_icon_unsorted_svg unless sorted

          case direction
          when :asc then sort_icon_asc_svg
          when :desc then sort_icon_desc_svg
          end
        end
      end
    end
  end
end
