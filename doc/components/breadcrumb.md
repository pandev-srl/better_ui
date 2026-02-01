# Breadcrumb

Breadcrumb navigation with configurable separators.

## Helper

```erb
<%= bui_breadcrumb(separator: :chevron) do |bc| %>
  <% bc.with_item(label: "Home", href: root_path) %>
  <% bc.with_item(label: "Products", href: products_path) %>
  <% bc.with_item(label: "Widget") %>
<% end %>
```

## BreadcrumbComponent Parameters

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| `separator` | Symbol | `:slash` | `:slash`, `:chevron`, `:dot` | Separator type between items |
| `size` | Symbol | `:md` | `:sm`, `:md`, `:lg` | Text size |
| `container_classes` | String | `nil` | — | Additional CSS classes |

## Slots

| Slot | Type | Description |
|------|------|-------------|
| `items` | Multiple | `Breadcrumb::ItemComponent` instances |

## ItemComponent Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `label` | String | Required | Item text |
| `href` | String | `nil` | Link URL (`nil` = current page, rendered as text) |

### Item Slots

| Slot | Type | Description |
|------|------|-------------|
| `icon_before` | Single | Icon before the label |

## Usage

### Basic Breadcrumb

```erb
<%= bui_breadcrumb do |bc| %>
  <% bc.with_item(label: "Home", href: root_path) %>
  <% bc.with_item(label: "Products", href: products_path) %>
  <% bc.with_item(label: "Current Page") %>
<% end %>
```

### Chevron Separator

```erb
<%= bui_breadcrumb(separator: :chevron) do |bc| %>
  <% bc.with_item(label: "Home", href: "/") %>
  <% bc.with_item(label: "Settings") %>
<% end %>
```

### With Icon

```erb
<%= bui_breadcrumb(separator: :chevron) do |bc| %>
  <% bc.with_item(label: "Home", href: "/") do |item| %>
    <% item.with_icon_before { bui_fa_icon("home", style: :solid, size: :xs) } %>
  <% end %>
  <% bc.with_item(label: "Users", href: "/users") %>
  <% bc.with_item(label: "John Doe") %>
<% end %>
```
