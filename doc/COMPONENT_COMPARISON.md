# Comparative Analysis: Old vs New BetterUi Components

## Differenze Architetturali

| Aspetto | Old (`../../better_ui`) | New (current) |
|---|---|---|
| **Organizzazione** | `general/` + `application/` | Flat + namespace (`drawer/`, `table/`, `dialog/`, `tabs/`, `forms/`, `breadcrumb/`) |
| **Varianti colore** | Nomi diretti: `default, white, red, rose, orange, green, blue, yellow, violet` | Semantiche: `primary, secondary, accent, success, danger, warning, info, light, dark` |
| **Stili** | Variano per componente (`filled, outline, light`, ecc.) | Uniformi: `solid, outline, ghost, soft` (+ `bordered` per card/table) |
| **Sizing** | `small, medium, large` (3 livelli) | `xs, sm, md, lg, xl` (5 livelli) |
| **Icone** | FontAwesome integrato (componente Icon dedicato) | Slot-based (`icon_before`, `icon_after`) + FaIconComponent wrapper |
| **Bordi arrotondati** | Parametro `rounded` esplicito | Generalmente integrato nel `size`; Table ha parametro `rounded:` esplicito (none/sm/md/lg/xl/full) |
| **Ombre** | Assenti o parametro dedicato | Sistema unificato `SHADOWS` in ApplicationComponent |
| **Stimulus** | Non presente | 10 controller Stimulus |
| **Base class** | Non chiara | `ApplicationComponent < ViewComponent::Base` con `css_classes()` e TailwindMerge |

---

## Tabella Comparativa Componenti

### Componenti General/Core

| Componente | Old | New | Note |
|---|---|---|---|
| **Button** | `general/button` | `ButtonComponent` | New ha slot icon_before/after, Stimulus loader, stili solid/outline/ghost/soft |
| **Card** | `general/card` | `CardComponent` | New ha 5 stili + bordered, shadow unificato |
| **Alert/Messages** | `general/alert` | `ActionMessagesComponent` | Old: singolo messaggio con icona auto. New: array di messaggi, Stimulus dismiss/auto-dismiss |
| **Avatar** | `general/avatar` | `AvatarComponent` | New ha shape, status indicator, iniziali auto, slot-based icon |
| **Badge** | `general/badge` | `BadgeComponent` | New ha variant dot/counter, stili solid/outline/soft/ghost, pill/rounded |
| **Breadcrumb** | `general/breadcrumb` | `Breadcrumb::BreadcrumbComponent` | New ha separatori multipli (slash/chevron/dot), ItemComponent con slot icon |
| **Heading** | `general/heading` | `HeadingComponent` | New ha livelli h1-h6, sottotitolo, divider, varianti colore semantiche |
| **Icon** | `general/icon` | `FaIconComponent` | New wrapper FontAwesome con spin/pulse/flip, sizing coerente |
| **Link** | `general/link` | `LinkComponent` | New ha stili underline/bold/text, icone slot-based, varianti colore |
| **Tag** | `general/tag` | `TagComponent` | New ha solid/outline/soft, dismissible con Stimulus, link mode |
| **Spinner** | `general/spinner` | `SpinnerComponent` | New ha stili e label opzionale, varianti colore semantiche |
| **Progress** | `general/progress` | `ProgressComponent` | New ha barra percentuale con label, varianti colore |
| **Divider** | `general/divider` | `DividerComponent` | New ha solid/dashed/dotted, orientamento, label |
| **Tooltip** | `general/tooltip` | `TooltipComponent` | New ha posizioni top/right/bottom/left, varianti colore |
| **Panel** | `general/panel` | -- | **MANCANTE nel new**. Old simile a Card ma con stili flat/raised/bordered |
| **Container** | `general/container` | `ContainerComponent` | New ha max-width responsive, fluid mode |

### Componenti Table

| Componente | Old | New | Note |
|---|---|---|---|
| **Table** | `general/table` (monolitico) | `table/TableComponent` | New: completamente riscritto con slot-based + collection mode, sub-componenti Row/Header/Cell/HeaderCell/Column, sortable headers con sort links, row highlighting, configurable rounded, scope attribute, partials system |
| **Row** | Sub-componenti inline | `table/RowComponent` | New: componente separato con slots |
| **Header** | Sub-componenti inline | `table/HeaderComponent` | New: componente separato |
| **Cell** | Sub-componenti inline | `table/CellComponent` | New: alignment, sizing indipendente |
| **HeaderCell** | Sub-componenti inline | `table/HeaderCellComponent` | New: componente separato |
| **Column** | -- | `table/ColumnComponent` | **NUOVO**. Configurazione colonne per collection mode |

### Componenti Layout/Navigation

| Componente | Old | New | Note |
|---|---|---|---|
| **Sidebar** | `application/sidebar` | `drawer/SidebarComponent` | New: ripensato come parte del sistema Drawer |
| **Navbar** | `application/navbar` | `drawer/HeaderComponent` | New: rinominato in Header, parte del Drawer |
| **Main** | `application/main` | `drawer/LayoutComponent` | New: layout completo con Stimulus per mobile drawer |
| **NavGroup** | -- | `drawer/NavGroupComponent` | **NUOVO**. Gruppi di navigazione con titolo |
| **NavItem** | -- | `drawer/NavItemComponent` | **NUOVO**. Item di navigazione con badge e Turbo |

### Componenti Dialog (TUTTI NUOVI)

| Componente | Old | New | Note |
|---|---|---|---|
| **Dialog** | -- | `dialog/DialogComponent` | **NUOVO**. Modal con `<dialog>`, Stimulus, backdrop |
| **Alert Dialog** | -- | `dialog/AlertComponent` | **NUOVO**. Dialog alert con icona e bottone OK |
| **Confirm Dialog** | -- | `dialog/ConfirmComponent` | **NUOVO**. Dialog conferma con confirm/cancel |

### Componenti Tabs (TUTTI NUOVI)

| Componente | Old | New | Note |
|---|---|---|---|
| **Tabs Container** | -- | `tabs/ContainerComponent` | **NUOVO**. JS mode + Turbo mode, stili underline/pills/bordered |
| **Tab** | -- | `tabs/TabComponent` | **NUOVO**. Tab button/link con icona e badge |
| **Tab Panel** | -- | `tabs/PanelComponent` | **NUOVO**. Pannello contenuto tab |

### Componenti Form

| Componente | Old | New | Note |
|---|---|---|---|
| **Form Base** | -- | `forms/BaseComponent` | **NUOVO**. Classe astratta con label/hint/errors/sizing unificati |
| **Text Input** | -- | `forms/TextInputComponent` | **NUOVO**. Con prefix/suffix icon slots |
| **Number Input** | -- | `forms/NumberInputComponent` | **NUOVO**. Con min/max/step/spinner |
| **Password Input** | -- | `forms/PasswordInputComponent` | **NUOVO**. Con Stimulus toggle visibilita |
| **Textarea** | -- | `forms/TextareaComponent` | **NUOVO**. Con resize control |
| **Checkbox** | -- | `forms/CheckboxComponent` | **NUOVO**. Con variant e label_position |
| **Checkbox Group** | -- | `forms/CheckboxGroupComponent` | **NUOVO**. Con collection e orientamento |
| **Select** | -- | `forms/SelectComponent` | **NUOVO**. Con dropdown custom, keyboard nav, clearable |

---

## Riepilogo Numerico

| Categoria | Old | New | Delta |
|---|---|---|---|
| **General/Core** | 17 | 15 | -2 |
| **Table** | 1 (monolitico) | 6 (modulare) | +5 |
| **Layout/Navigation** | 3 | 5 | +2 |
| **Dialog** | 0 | 3 | +3 |
| **Tabs** | 0 | 3 | +3 |
| **Forms** | 0 | 8 | +8 |
| **TOTALE** | 20 | 40 | +20 |

## Componenti Old MANCANTI nel New (da migrare)

1. **Panel** - Container con header/body/footer (simile a Card ma con stili flat/raised/bordered)

## Componenti New NON PRESENTI nel Old (aggiunte)

1. **Dialog** (3 componenti) - Sistema modale completo
2. **Tabs** (3 componenti) - Interfaccia a schede JS/Turbo
3. **Forms** (8 componenti) - Sistema form completo con SelectComponent
4. **Table sub-components** (5 nuovi) - Table modulare
5. **NavGroup + NavItem** - Navigazione granulare nel Drawer
