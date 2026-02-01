# Confronto Componenti: BetterUi v1 (Alessio) vs BetterUi v2 (Corrente)

## Riepilogo

| Categoria                     | v1 (Alessio) | v2 (Corrente) |
| ----------------------------- | ------------ | ------------- |
| General/UI Components         | 18           | 4             |
| Application/Layout Components | 3            | 5             |
| Form Components               | 0            | 7             |
| Table Components              | 7            | 0             |
| **Totale**                    | **28**       | **16**        |

---

## Componenti v1 (Alessio) - Stato Implementazione v2

### General Components

| #   | Componente v1  | Path v1                           | Stato v2            | Note                                                |
| --- | -------------- | --------------------------------- | ------------------- | --------------------------------------------------- |
| 1   | **Button**     | `general/button/component.rb`     | ✅ Implementato     | `ButtonComponent` - Rifatto con varianti semantiche |
| 2   | **Badge**      | `general/badge/component.rb`      | ❌ Non implementato | -                                                   |
| 3   | **Avatar**     | `general/avatar/component.rb`     | ❌ Non implementato | -                                                   |
| 4   | **Heading**    | `general/heading/component.rb`    | ❌ Non implementato | -                                                   |
| 5   | **Icon**       | `general/icon/component.rb`       | ❌ Non implementato | -                                                   |
| 6   | **Link**       | `general/link/component.rb`       | ❌ Non implementato | -                                                   |
| 7   | **Alert**      | `general/alert/component.rb`      | ✅ Implementato     | `ActionMessagesComponent` - Simile funzionalità     |
| 8   | **Card**       | `general/card/component.rb`       | ✅ Implementato     | `CardComponent` - Rifatto con slots                 |
| 9   | **Panel**      | `general/panel/component.rb`      | ❌ Non implementato | Potrebbe essere coperto da Card                     |
| 10  | **Breadcrumb** | `general/breadcrumb/component.rb` | ❌ Non implementato | -                                                   |
| 11  | **Spinner**    | `general/spinner/component.rb`    | ❌ Non implementato | Parziale: loading state in Button                   |
| 12  | **Progress**   | `general/progress/component.rb`   | ❌ Non implementato | -                                                   |
| 13  | **Divider**    | `general/divider/component.rb`    | ❌ Non implementato | -                                                   |
| 14  | **Container**  | `general/container/component.rb`  | ❌ Non implementato | -                                                   |
| 15  | **Tag**        | `general/tag/component.rb`        | ❌ Non implementato | -                                                   |
| 16  | **Tooltip**    | `general/tooltip/component.rb`    | ❌ Non implementato | -                                                   |
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

| #   | Componente v2                     | Descrizione                            |
| --- | --------------------------------- | -------------------------------------- |
| 1   | **Forms::BaseComponent**          | Classe base astratta per form inputs   |
| 2   | **Forms::TextInputComponent**     | Input di testo con prefix/suffix icons |
| 3   | **Forms::NumberInputComponent**   | Input numerico con min/max/step        |
| 4   | **Forms::PasswordInputComponent** | Password con toggle visibilità         |
| 5   | **Forms::TextareaComponent**      | Textarea multi-linea                   |
| 6   | **Forms::CheckboxComponent**      | Checkbox singolo                       |
| 7   | **Forms::CheckboxGroupComponent** | Gruppo di checkbox                     |
| 8   | **UiFormBuilder**                 | Form builder Rails integrato           |

### Layout Components Aggiuntivi

| #   | Componente v2                 | Descrizione                   |
| --- | ----------------------------- | ----------------------------- |
| 1   | **Drawer::NavGroupComponent** | Gruppo di navigazione sidebar |
| 2   | **Drawer::NavItemComponent**  | Item singolo di navigazione   |

---

## Differenze Architetturali

| Aspetto                  | v1 (Alessio)                           | v2 (Corrente)                           |
| ------------------------ | -------------------------------------- | --------------------------------------- |
| **Namespace**            | `BetterUi::General::Button::Component` | `BetterUi::ButtonComponent`             |
| **Varianti colore**      | Colori diretti (red, blue, green...)   | Semantici (primary, success, danger...) |
| **CSS**                  | SCSS compilato + Tailwind v3           | Tailwind CSS v4 puro (OKLCH)            |
| **JavaScript**           | Nessun Stimulus controller             | 4 Stimulus controllers                  |
| **Form Builder**         | Solo placeholder                       | Completamente implementato              |
| **Distribuzione CSS/JS** | Asset pipeline Rails                   | npm package separato                    |
| **Preview system**       | test/components/previews               | spec/components/previews (Lookbook)     |

---

## Componenti da Migrare (Priorità Suggerita)

### Alta Priorità

1. **Badge** - Molto usato per status/contatori
2. **Spinner** - Utile per loading states standalone
3. **Avatar** - Comune in UI utente

### Media Priorità

4. **Breadcrumb** - Navigazione
5. **Progress** - Feedback visivo
6. **Tooltip** - UX migliorata
7. **Tag** - Categorizzazione

### Bassa Priorità

8. **Heading** - Può usare Tailwind diretto
9. **Icon** - Dipende da libreria icone
10. **Link** - Rails helper sufficiente
11. **Panel** - Coperto da Card
12. **Divider** - Semplice con Tailwind
13. **Container** - Layout Tailwind

---

## Statistiche

- **Componenti v1 migrati in v2:** 13/28 (46%) — Button, Alert, Card, Navbar, Sidebar, Main/Layout + Table (7 componenti: Table, TR, TH, TD, THEAD, TBODY, TFOOT)
- **Componenti v1 da migrare:** 15
- **Componenti nuovi in v2:** 10 (principalmente Forms)
