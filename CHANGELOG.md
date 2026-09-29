## [1.0.0] — UNRELEASED

This release marks the gem to be stable enough.

### Changed

- Moved to Ruby 3.4+.

### Added

- `Magic::Lookup#for`
  to respect autoloadable lookup classes.
- `Magic::Lookup#namespaced_name_for`.
- Rails support (optional, not a dependency):
  - Ported `Magic.eager_load` from Magic Presenter
    to eagerly load different class scopes, be them presenters, models or whatever else.
  - `Magic::Lookup::Scope.[]`
    for the scoped classes to be available for reverse lookup in development environment.

#### Reverse lookup

- `Magic::Lookup::Scope`
  to be included in class scopes.
  - `Magic::Lookup::Scope#for`
    for reverse lookups.
  - `Magic::Lookup::Scope#classes`
    to get classes within a scope.
- Minor lookup helpers:
  - `Magic::Lookup#match?`,
  - `Magic::Lookup#name_match?`.

### Fixed

- A class with no namespaces configured should respect those of its ancestors.
- Lookup error messages should suggest namespaced names if no empty namespace is configured.


## [0.3.1] — 2026-05-05

Works with Ruby 4+.


## [0.3.0] — 2025-05-20

### Added

- `Magic::Lookup#for`
  to consider `self` a part of a lookup scope.


## [0.2.0] — 2024-10-19

### Added

- Optional `namespace` parameter to `Magic::Lookup#for`
  for class lookups within a namespace.
- `Magic::Lookup#namespaces`
  to set default lookup namespaces.


## [0.1.0] — 2024-10-10

### Added

- `Magic::Lookup#for`
  for name-based class lookups.
- `Magic::Lookup::Error`
  to be used when lookup fails.
- `Magic::Lookup::Error.for`
  factory helper.
