## [1.0.0] — UNRELEASED

This release marks the gem to be stable enough.

### Changed

- Moved to Ruby 3.4+.

### Added

- `Magic::Lookup#for` to respect autoloadable lookup classes.
- Rails support (optional, not a dependency):
  - Ported `Magic.eager_load` from Magic Presenter to eagerly load different class scopes, be them presenters, models or whatever else.


## [0.3.1] — 2026-05-05

Works with Ruby 4+.


## [0.3.0] — 2025-05-20

### Added

- `Magic::Lookup#for` to consider `self` a part of a lookup scope.


## [0.2.0] — 2024-10-19

### Added

- Optional `namespace` parameter to `Magic::Lookup#for` for class lookups within a namespace.
- `Magic::Lookup#namespaces` to set default lookup namespaces.


## [0.1.0] — 2024-10-10

### Added

- `Magic::Lookup#for` for name-based class lookups.
- `Magic::Lookup::Error` to be used when lookup fails.
- `Magic::Lookup::Error.for` factory helper.
