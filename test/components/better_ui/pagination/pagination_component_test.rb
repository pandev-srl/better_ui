# frozen_string_literal: true

require "test_helper"

module BetterUi
  module Pagination
    class PaginationComponentTest < ActiveSupport::TestCase
      # Helper to build a simple url proc for tests
      def url_proc
        ->(page) { "/items?page=#{page}" }
      end

      # ============================================
      # Page Window Algorithm Tests
      # ============================================

      test "page_items returns empty array for 0 total pages" do
        component = PaginationComponent.new(current_page: 1, total_pages: 0, url: url_proc)
        assert_equal [], component.send(:page_items)
      end

      test "page_items returns [1] for 1 total page" do
        component = PaginationComponent.new(current_page: 1, total_pages: 1, url: url_proc)
        assert_equal [1], component.send(:page_items)
      end

      test "page_items returns all pages when total <= 2*window+3" do
        component = PaginationComponent.new(current_page: 1, total_pages: 5, url: url_proc, window: 2)
        assert_equal [1, 2, 3, 4, 5], component.send(:page_items)
      end

      test "page_items near start with gap at end" do
        component = PaginationComponent.new(current_page: 1, total_pages: 10, url: url_proc, window: 2)
        assert_equal [1, 2, 3, :gap, 10], component.send(:page_items)
      end

      test "page_items near end with gap at start" do
        component = PaginationComponent.new(current_page: 10, total_pages: 10, url: url_proc, window: 2)
        assert_equal [1, :gap, 8, 9, 10], component.send(:page_items)
      end

      test "page_items in the middle with gaps on both sides" do
        component = PaginationComponent.new(current_page: 10, total_pages: 20, url: url_proc, window: 2)
        assert_equal [1, :gap, 8, 9, 10, 11, 12, :gap, 20], component.send(:page_items)
      end

      test "page_items collapses gap to actual page when only 1 page is hidden" do
        # current=4, total=7, window=2: window is [2,3,4,5,6], first=1, last=7
        # Between first(1) and window_start(2): nothing hidden
        # Between window_end(6) and last(7): nothing hidden
        component = PaginationComponent.new(current_page: 4, total_pages: 7, url: url_proc, window: 2)
        assert_equal [1, 2, 3, 4, 5, 6, 7], component.send(:page_items)
      end

      test "page_items collapses single hidden page instead of gap" do
        # current=5, total=10, window=2: window is [3,4,5,6,7]
        # Between first(1) and 3: page 2 is hidden (only 1 page) -> show 2 instead of gap
        # Between 7 and last(10): pages 8,9 hidden (>1) -> gap
        component = PaginationComponent.new(current_page: 5, total_pages: 10, url: url_proc, window: 2)
        assert_equal [1, 2, 3, 4, 5, 6, 7, :gap, 10], component.send(:page_items)
      end

      test "page_items with window 1" do
        component = PaginationComponent.new(current_page: 5, total_pages: 10, url: url_proc, window: 1)
        assert_equal [1, :gap, 4, 5, 6, :gap, 10], component.send(:page_items)
      end

      test "page_items with window 0" do
        component = PaginationComponent.new(current_page: 5, total_pages: 10, url: url_proc, window: 0)
        assert_equal [1, :gap, 5, :gap, 10], component.send(:page_items)
      end

      test "page_items with large window shows all pages" do
        component = PaginationComponent.new(current_page: 5, total_pages: 10, url: url_proc, window: 10)
        assert_equal [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], component.send(:page_items)
      end

      # ============================================
      # Rendering Tests - Basic Structure
      # ============================================

      test "renders nothing when total_pages is 0" do
        render_inline(PaginationComponent.new(current_page: 1, total_pages: 0, url: url_proc))
        refute_selector "nav"
      end

      test "renders nothing when total_pages is 1" do
        render_inline(PaginationComponent.new(current_page: 1, total_pages: 1, url: url_proc))
        refute_selector "nav"
      end

      test "renders nav element with aria-label" do
        render_inline(PaginationComponent.new(current_page: 1, total_pages: 5, url: url_proc))
        assert_selector "nav[aria-label='Pagination']"
      end

      test "renders ul with role list" do
        render_inline(PaginationComponent.new(current_page: 1, total_pages: 5, url: url_proc))
        assert_selector "nav ul[role='list']"
      end

      test "renders page number links" do
        render_inline(PaginationComponent.new(current_page: 1, total_pages: 5, url: url_proc))
        assert_selector "a[href='/items?page=2']", text: "2"
        assert_selector "a[href='/items?page=3']", text: "3"
      end

      test "renders current page as span not link" do
        render_inline(PaginationComponent.new(current_page: 3, total_pages: 5, url: url_proc))
        assert_selector "span[aria-current='page']", text: "3"
        refute_selector "a[aria-current='page']"
      end

      test "renders page links with aria-label" do
        render_inline(PaginationComponent.new(current_page: 1, total_pages: 5, url: url_proc))
        assert_selector "a[aria-label='Go to page 2']"
      end

      # ============================================
      # Previous / Next Buttons
      # ============================================

      test "renders prev and next buttons by default" do
        render_inline(PaginationComponent.new(current_page: 3, total_pages: 5, url: url_proc))
        assert_selector "a[rel='prev']"
        assert_selector "a[rel='next']"
      end

      test "prev button links to previous page" do
        render_inline(PaginationComponent.new(current_page: 3, total_pages: 5, url: url_proc))
        assert_selector "a[rel='prev'][href='/items?page=2']"
      end

      test "next button links to next page" do
        render_inline(PaginationComponent.new(current_page: 3, total_pages: 5, url: url_proc))
        assert_selector "a[rel='next'][href='/items?page=4']"
      end

      test "prev button is disabled on first page" do
        render_inline(PaginationComponent.new(current_page: 1, total_pages: 5, url: url_proc))
        assert_selector "span[aria-disabled='true'][aria-label='Previous page']"
        refute_selector "a[rel='prev']"
      end

      test "next button is disabled on last page" do
        render_inline(PaginationComponent.new(current_page: 5, total_pages: 5, url: url_proc))
        assert_selector "span[aria-disabled='true'][aria-label='Next page']"
        refute_selector "a[rel='next']"
      end

      test "hides prev/next when show_prev_next is false" do
        render_inline(PaginationComponent.new(current_page: 3, total_pages: 5, url: url_proc, show_prev_next: false))
        refute_selector "a[rel='prev']"
        refute_selector "a[rel='next']"
      end

      # ============================================
      # First / Last Buttons
      # ============================================

      test "does not show first/last buttons by default" do
        render_inline(PaginationComponent.new(current_page: 3, total_pages: 5, url: url_proc))
        refute_selector "[aria-label='First page']"
        refute_selector "[aria-label='Last page']"
      end

      test "shows first/last buttons when show_first_last is true" do
        render_inline(PaginationComponent.new(current_page: 3, total_pages: 5, url: url_proc, show_first_last: true))
        assert_selector "a[aria-label='First page'][href='/items?page=1']"
        assert_selector "a[aria-label='Last page'][href='/items?page=5']"
      end

      test "first button is disabled on first page" do
        render_inline(PaginationComponent.new(current_page: 1, total_pages: 5, url: url_proc, show_first_last: true))
        assert_selector "span[aria-disabled='true'][aria-label='First page']"
      end

      test "last button is disabled on last page" do
        render_inline(PaginationComponent.new(current_page: 5, total_pages: 5, url: url_proc, show_first_last: true))
        assert_selector "span[aria-disabled='true'][aria-label='Last page']"
      end

      # ============================================
      # Gap (Ellipsis)
      # ============================================

      test "renders gap as span with aria-hidden" do
        render_inline(PaginationComponent.new(current_page: 1, total_pages: 10, url: url_proc))
        assert_selector "span[aria-hidden='true']", text: "\u2026"
      end

      test "renders custom gap label" do
        render_inline(PaginationComponent.new(current_page: 1, total_pages: 10, url: url_proc, gap_label: "..."))
        assert_selector "span[aria-hidden='true']", text: "..."
      end

      # ============================================
      # Custom Labels
      # ============================================

      test "renders custom prev label text" do
        render_inline(PaginationComponent.new(current_page: 3, total_pages: 5, url: url_proc, prev_label: "Back"))
        assert_selector "a[rel='prev']", text: "Back"
      end

      test "renders custom next label text" do
        render_inline(PaginationComponent.new(current_page: 3, total_pages: 5, url: url_proc, next_label: "Forward"))
        assert_selector "a[rel='next']", text: "Forward"
      end

      test "renders custom first label text" do
        render_inline(PaginationComponent.new(current_page: 3, total_pages: 5, url: url_proc, show_first_last: true, first_label: "Start"))
        assert_selector "a[aria-label='First page']", text: "Start"
      end

      test "renders custom last label text" do
        render_inline(PaginationComponent.new(current_page: 3, total_pages: 5, url: url_proc, show_first_last: true, last_label: "End"))
        assert_selector "a[aria-label='Last page']", text: "End"
      end

      test "renders SVG icons when labels are nil" do
        render_inline(PaginationComponent.new(current_page: 3, total_pages: 5, url: url_proc))
        assert_selector "a[rel='prev'] svg"
        assert_selector "a[rel='next'] svg"
      end

      # ============================================
      # show_page_numbers
      # ============================================

      test "hides page numbers when show_page_numbers is false" do
        render_inline(PaginationComponent.new(current_page: 3, total_pages: 5, url: url_proc, show_page_numbers: false))
        refute_selector "a[aria-label='Go to page 1']"
        refute_selector "span[aria-current='page']"
        # prev/next should still be present
        assert_selector "a[rel='prev']"
        assert_selector "a[rel='next']"
      end

      # ============================================
      # Variant Tests
      # ============================================

      test "renders with default primary variant" do
        render_inline(PaginationComponent.new(current_page: 3, total_pages: 5, url: url_proc))
        # Active page should have primary styling
        assert_selector "span[aria-current='page']"
      end

      BetterUi::ApplicationComponent::VARIANTS.each_key do |variant|
        test "renders #{variant} variant without error" do
          render_inline(PaginationComponent.new(current_page: 3, total_pages: 5, url: url_proc, variant: variant))
          assert_selector "nav[aria-label='Pagination']"
        end
      end

      test "raises error for invalid variant" do
        error = assert_raises(ArgumentError) do
          PaginationComponent.new(current_page: 1, total_pages: 5, url: url_proc, variant: :invalid)
        end
        assert_match(/Invalid variant/, error.message)
      end

      # ============================================
      # Style Tests
      # ============================================

      test "renders outline style by default" do
        render_inline(PaginationComponent.new(current_page: 3, total_pages: 5, url: url_proc))
        assert_selector "nav[aria-label='Pagination']"
      end

      %i[solid outline ghost soft].each do |style|
        test "renders #{style} style without error" do
          render_inline(PaginationComponent.new(current_page: 3, total_pages: 5, url: url_proc, style: style))
          assert_selector "nav[aria-label='Pagination']"
        end
      end

      test "raises error for invalid style" do
        error = assert_raises(ArgumentError) do
          PaginationComponent.new(current_page: 1, total_pages: 5, url: url_proc, style: :invalid)
        end
        assert_match(/Invalid style/, error.message)
      end

      # ============================================
      # Size Tests
      # ============================================

      test "renders md size by default" do
        render_inline(PaginationComponent.new(current_page: 3, total_pages: 5, url: url_proc))
        assert_selector "nav[aria-label='Pagination']"
      end

      %i[xs sm md lg xl].each do |size|
        test "renders #{size} size without error" do
          render_inline(PaginationComponent.new(current_page: 3, total_pages: 5, url: url_proc, size: size))
          assert_selector "nav[aria-label='Pagination']"
        end
      end

      test "raises error for invalid size" do
        error = assert_raises(ArgumentError) do
          PaginationComponent.new(current_page: 1, total_pages: 5, url: url_proc, size: :invalid)
        end
        assert_match(/Invalid size/, error.message)
      end

      # ============================================
      # Rounded Tests
      # ============================================

      %i[none sm md lg full].each do |rounded|
        test "renders #{rounded} rounded without error" do
          render_inline(PaginationComponent.new(current_page: 3, total_pages: 5, url: url_proc, rounded: rounded))
          assert_selector "nav[aria-label='Pagination']"
        end
      end

      test "raises error for invalid rounded" do
        error = assert_raises(ArgumentError) do
          PaginationComponent.new(current_page: 1, total_pages: 5, url: url_proc, rounded: :invalid)
        end
        assert_match(/Invalid rounded/, error.message)
      end

      # ============================================
      # Shadow Tests
      # ============================================

      test "renders with shadow" do
        render_inline(PaginationComponent.new(current_page: 3, total_pages: 5, url: url_proc, shadow: :md))
        assert_selector "nav[aria-label='Pagination']"
      end

      # ============================================
      # Info Slot
      # ============================================

      test "renders info slot content" do
        render_inline(PaginationComponent.new(current_page: 3, total_pages: 5, url: url_proc)) do |pg|
          pg.with_info { "Showing 21-30 of 50 results" }
        end
        assert_text "Showing 21-30 of 50 results"
      end

      test "renders auto info text when show_info is true with total_count and per_page" do
        render_inline(PaginationComponent.new(
          current_page: 2,
          total_pages: 5,
          url: url_proc,
          show_info: true,
          per_page: 10,
          total_count: 50
        ))
        assert_text "Showing 11-20 of 50 results"
      end

      test "auto info text shows correct range on last page" do
        render_inline(PaginationComponent.new(
          current_page: 5,
          total_pages: 5,
          url: url_proc,
          show_info: true,
          per_page: 10,
          total_count: 47
        ))
        assert_text "Showing 41-47 of 47 results"
      end

      test "auto info text shows correct range on first page" do
        render_inline(PaginationComponent.new(
          current_page: 1,
          total_pages: 5,
          url: url_proc,
          show_info: true,
          per_page: 10,
          total_count: 50
        ))
        assert_text "Showing 1-10 of 50 results"
      end

      test "info slot takes precedence over auto info" do
        render_inline(PaginationComponent.new(
          current_page: 1,
          total_pages: 5,
          url: url_proc,
          show_info: true,
          per_page: 10,
          total_count: 50
        )) do |pg|
          pg.with_info { "Custom info" }
        end
        assert_text "Custom info"
      end

      # ============================================
      # Container Classes
      # ============================================

      test "applies custom container classes" do
        render_inline(PaginationComponent.new(current_page: 3, total_pages: 5, url: url_proc, container_classes: "my-custom-class"))
        assert_selector "nav.my-custom-class"
      end

      # ============================================
      # Validation Tests
      # ============================================

      test "raises error when current_page is less than 1" do
        error = assert_raises(ArgumentError) do
          PaginationComponent.new(current_page: 0, total_pages: 5, url: url_proc)
        end
        assert_match(/current_page must be >= 1/, error.message)
      end

      test "raises error when total_pages is negative" do
        error = assert_raises(ArgumentError) do
          PaginationComponent.new(current_page: 1, total_pages: -1, url: url_proc)
        end
        assert_match(/total_pages must be >= 0/, error.message)
      end

      test "raises error when current_page exceeds total_pages" do
        error = assert_raises(ArgumentError) do
          PaginationComponent.new(current_page: 6, total_pages: 5, url: url_proc)
        end
        assert_match(/current_page .* cannot exceed total_pages/, error.message)
      end

      test "does not raise error when current_page equals total_pages" do
        component = PaginationComponent.new(current_page: 5, total_pages: 5, url: url_proc)
        assert_instance_of PaginationComponent, component
      end

      test "raises error when url is not a proc" do
        error = assert_raises(ArgumentError) do
          PaginationComponent.new(current_page: 1, total_pages: 5, url: "not a proc")
        end
        assert_match(/url must be a Proc/, error.message)
      end

      # ============================================
      # Active page styling per style
      # ============================================

      test "solid style active page has filled background" do
        render_inline(PaginationComponent.new(current_page: 3, total_pages: 5, url: url_proc, style: :solid))
        assert_selector "span[aria-current='page'].bg-primary-600"
      end

      test "outline style active page has border" do
        render_inline(PaginationComponent.new(current_page: 3, total_pages: 5, url: url_proc, style: :outline))
        assert_selector "span[aria-current='page'].border-primary-600"
      end

      test "ghost style active page has light background" do
        render_inline(PaginationComponent.new(current_page: 3, total_pages: 5, url: url_proc, style: :ghost))
        assert_selector "span[aria-current='page'].bg-primary-100"
      end

      test "soft style active page has soft background" do
        render_inline(PaginationComponent.new(current_page: 3, total_pages: 5, url: url_proc, style: :soft))
        assert_selector "span[aria-current='page'].bg-primary-100"
      end

      # ============================================
      # Solid variant active classes
      # ============================================

      test "solid danger active page" do
        render_inline(PaginationComponent.new(current_page: 3, total_pages: 5, url: url_proc, style: :solid, variant: :danger))
        assert_selector "span[aria-current='page'].bg-danger-600"
      end

      test "solid success active page" do
        render_inline(PaginationComponent.new(current_page: 3, total_pages: 5, url: url_proc, style: :solid, variant: :success))
        assert_selector "span[aria-current='page'].bg-success-600"
      end

      test "solid light active page" do
        render_inline(PaginationComponent.new(current_page: 3, total_pages: 5, url: url_proc, style: :solid, variant: :light))
        assert_selector "span[aria-current='page'].bg-grayscale-200"
      end

      test "solid dark active page" do
        render_inline(PaginationComponent.new(current_page: 3, total_pages: 5, url: url_proc, style: :solid, variant: :dark))
        assert_selector "span[aria-current='page'].bg-grayscale-900"
      end

      # ============================================
      # Two pages edge case
      # ============================================

      test "renders correctly with 2 total pages on page 1" do
        render_inline(PaginationComponent.new(current_page: 1, total_pages: 2, url: url_proc))
        assert_selector "span[aria-current='page']", text: "1"
        assert_selector "a[href='/items?page=2']", text: "2"
      end

      test "renders correctly with 2 total pages on page 2" do
        render_inline(PaginationComponent.new(current_page: 2, total_pages: 2, url: url_proc))
        assert_selector "a[href='/items?page=1']", text: "1"
        assert_selector "span[aria-current='page']", text: "2"
      end
    end
  end
end
