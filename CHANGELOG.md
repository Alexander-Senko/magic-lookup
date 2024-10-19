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
