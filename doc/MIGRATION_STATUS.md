# Confronto Componenti: BetterUi v1 (Alessio) vs BetterUi v2 (Corrente)

## Riepilogo

| Categoria                     | v1 (Alessio) | v2 (Corrente) |
| ----------------------------- | ------------ | ------------- |
| General/UI Components         | 18           | 16            |
| Application/Layout Components | 3            | 5             |
| Form Components               | 0            | 9             |
| Table Components              | 7            | 6             |
| Dialog Components             | 0            | 3             |
| Tabs Components               | 0            | 3             |
| **Totale**                    | **28**       | **42**        |

---

## Componenti v1 (Alessio) - Stato Implementazione v2

### General Components

| #   | Componente v1  | Path v1                           | Stato v2            | Note                                                |
| --- | -------------- | --------------------------------- | ------------------- | --------------------------------------------------- |
| 1   | **Button**     | `general/button/component.rb`     | ✅ Implementato     | `ButtonComponent` - Rifatto con varianti semantiche |
| 2   | **Badge**      | `general/badge/component.rb`      | ✅ Implementato     | `BadgeComponent` - Con dot, counter, pill, stili solid/outline/soft/ghost |
| 3   | **Avatar**     | `general/avatar/component.rb`     | ✅ Implementato     | `AvatarComponent` - Con shape, status indicator, iniziali auto |
| 4   | **Heading**    | `general/heading/component.rb`    | ✅ Implementato     | `HeadingComponent` - Livelli h1-h6, sottotitolo, divider, actions slot |
| 5   | **Icon**       | `general/icon/component.rb`       | ✅ Implementato     | `FaIconComponent` - Wrapper FontAwesome con spin/pulse/flip/rotate |
| 6   | **Link**       | `general/link/component.rb`       | ✅ Implementato     | `LinkComponent` - Con stili default/underline/ghost, icone slot |
| 7   | **Alert**      | `general/alert/component.rb`      | ✅ Implementato     | `ActionMessagesComponent` - Simile funzionalità     |
| 8   | **Card**       | `general/card/component.rb`       | ✅ Implementato     | `CardComponent` - Rifatto con slots                 |
| 9   | **Panel**      | `general/panel/component.rb`      | ➖ Non necessario   | Funzionalità coperta da CardComponent (style: :bordered) |
| 10  | **Breadcrumb** | `general/breadcrumb/component.rb` | ✅ Implementato     | `Breadcrumb::BreadcrumbComponent` - Con separatori slash/chevron/dot |
| 11  | **Spinner**    | `general/spinner/component.rb`    | ✅ Implementato     | `SpinnerComponent` - Standalone con varianti e label |
| 12  | **Progress**   | `general/progress/component.rb`   | ✅ Implementato     | `ProgressComponent` - Con label, show_value, animated |
| 13  | **Divider**    | `general/divider/component.rb`    | ✅ Implementato     | `DividerComponent` - Con solid/dashed/dotted, orientamento, label |
| 14  | **Container**  | `general/container/component.rb`  | ✅ Implementato     | `ContainerComponent` - Con max-width responsive, padding, centered |
| 15  | **Tag**        | `general/tag/component.rb`        | ✅ Implementato     | `TagComponent` - Con solid/outline/soft, dismissible, link mode |
| 16  | **Tooltip**    | `general/tooltip/component.rb`    | ✅ Implementato     | `TooltipComponent` - CSS-only con posizioni top/right/bottom/left |
| 17  | **Table**      | `general/table/component.rb`      | ✅ Implementato     | `Table::TableComponent` - Riscritto con slot/collection mode, sortable, highlighted, rounded, partials |

### Table Sub-Components (v1)

| #   | Componente v1 | Stato v2            | Note                                  |
| --- | ------------- | ------------------- | ------------------------------------- |
| 1   | **TR**        | ✅ Implementato     | `Table::RowComponent` con striped/hoverable/highlighted |
| 2   | **TH**        | ✅ Implementato     | `Table::HeaderCellComponent` con scope/sortable |
| 3   | **TD**        | ✅ Implementato     | `Table::CellComponent` con alignment/sizing |
| 4   | **THEAD**     | ✅ Implementato     | `Table::HeaderComponent` con cell slots |
| 5   | **TBODY**     | ✅ Implementato     | Integrato in `Table::TableComponent` template |
| 6   | **TFOOT**     | ✅ Implementato     | Integrato in `Table::TableComponent` con footer_row slot e footer_partial |

### Application/Layout Components

| #   | Componente v1   | Path v1                            | Stato v2        | Note                       |
| --- | --------------- | ---------------------------------- | --------------- | -------------------------- |
| 1   | **Navbar**      | `application/navbar/component.rb`  | ✅ Implementato | `Drawer::HeaderComponent`  |
| 2   | **Sidebar**     | `application/sidebar/component.rb` | ✅ Implementato | `Drawer::SidebarComponent` |
| 3   | **Main/Layout** | `application/main/component.rb`    | ✅ Implementato | `Drawer::LayoutComponent`  |

---

## Componenti NUOVI in v2 (non presenti in v1)

### Form Components (completamente nuovi)

| #   | Componente v2                     | Helper                | Descrizione                            |
| --- | --------------------------------- | --------------------- | -------------------------------------- |
| 1   | **Forms::BaseComponent**          | —                     | Classe base astratta per form inputs   |
| 2   | **Forms::TextInputComponent**     | `bui_text_input`      | Input di testo con prefix/suffix icons |
| 3   | **Forms::NumberInputComponent**   | `bui_number_input`    | Input numerico con min/max/step        |
| 4   | **Forms::PasswordInputComponent** | `bui_password_input`  | Password con toggle visibilita         |
| 5   | **Forms::TextareaComponent**      | `bui_textarea`        | Textarea multi-linea                   |
| 6   | **Forms::CheckboxComponent**      | `bui_checkbox`        | Checkbox singolo                       |
| 7   | **Forms::CheckboxGroupComponent** | `bui_checkbox_group`  | Gruppo di checkbox                     |
| 8   | **Forms::SelectComponent**        | `bui_select`          | Select custom con dropdown, keyboard nav |
| 9   | **UiFormBuilder**                 | —                     | Form builder Rails integrato           |

### Dialog Components (completamente nuovi)

| #   | Componente v2                 | Helper               | Descrizione                   |
| --- | ----------------------------- | -------------------- | ----------------------------- |
| 1   | **Dialog::DialogComponent**   | `bui_dialog`         | Modal con `<dialog>`, Stimulus, backdrop |
| 2   | **Dialog::AlertComponent**    | `bui_dialog_alert`   | Dialog alert con icona e bottone OK |
| 3   | **Dialog::ConfirmComponent**  | `bui_dialog_confirm` | Dialog conferma con confirm/cancel |

### Tabs Components (completamente nuovi)

| #   | Componente v2                 | Helper           | Descrizione                   |
| --- | ----------------------------- | ---------------- | ----------------------------- |
| 1   | **Tabs::ContainerComponent**  | `bui_tabs`       | JS mode + Turbo mode, stili underline/pills/bordered |
| 2   | **Tabs::TabComponent**        | `bui_tab`        | Tab button/link con icona e badge |
| 3   | **Tabs::PanelComponent**      | `bui_tab_panel`  | Pannello contenuto tab |

### Layout Components Aggiuntivi

| #   | Componente v2                 | Helper                | Descrizione                   |
| --- | ----------------------------- | --------------------- | ----------------------------- |
| 1   | **Drawer::NavGroupComponent** | `bui_drawer_nav_group` | Gruppo di navigazione sidebar |
| 2   | **Drawer::NavItemComponent**  | `bui_drawer_nav_item`  | Item singolo di navigazione   |

---

## Statistiche

- **Componenti v1 migrati in v2:** 27/28 (96%) — Tutti tranne Panel (coperto da Card)
- **Componenti v1 da migrare:** 0 (Panel funzionalmente coperto da Card)
- **Componenti nuovi in v2:** 19 (Forms 9, Dialog 3, Tabs 3, Nav 2, Table::ColumnComponent 1, SelectComponent)
- **Totale componenti v2:** 42
