![Code Climate maintainability](
	https://img.shields.io/codeclimate/maintainability-percentage/Alexander-Senko/magic-lookup
)
![Code Climate coverage](
	https://img.shields.io/codeclimate/coverage/Alexander-Senko/magic-lookup
)

## What is it for?

A bit of history: this gem was inspired by digging deeper into [Draper](https://github.com/drapergem/draper) with an eye on refactoring.

A common task for an application is to match its parts against each other, be it inferring a default model class for a controller, or looking up a decorator for a model, or whatever else.

Modern frameworks tend to use naming conventions over configuration to achieve that.
Unfortunately, every one has to implement them on its own struggling through numerous bugs.
Moreover, inconsistencies across these implementations lead to misunderstanding and endless tickets when actual behavior fails to meet user expectations based on other frameworks.

So, meet

# 🔮 Magic Lookup

It’s meant to be The One to Rule Them All — the library to provide a generic name-based lookup for a plenty of cases.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add magic-lookup

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install magic-lookup

## Usage

These are the steps to set up an automatic class inference:

1. Define a base class extending `Magic::Lookup`.
2. Define `.name_for` method for that class implementing your lookup logic.
3. From the base class, inherit classes to be looked up.

```ruby
class Scope
  extend Magic::Lookup

  def self.name_for object_class
    object_class.name
        .delete_suffix('Model')
        .concat('Scope')
  end
end

class MyScope < Scope
end

Scope.for MyModel    # => MyScope
Scope.for OtherModel # => nil
```

### Exception handling

When no class is found, `nil` is returned. If you need to raise an exception in this case, you can use `Magic::Lookup::Error` like this:

```ruby
scope_class = Scope.for(object.class) or
    raise Magic::Lookup::Error.for(object, Scope)
```

`Magic::Lookup::Error` is never raised internally and is meant to be used in your code that implements the lookup logic.

## 🔮 Magic

### Inheritance

Lookup is provided not only for the class itself, but to any of its ancestors as well.

### Namespaces

Both of matching classes — the target and its match — may be namespaced independently.

One can specify a namespace to look in:

```ruby
Scope.for MyModel              # => MyScope
Scope.for MyModel, MyNamespace # => MyNamespace::MyScope
```

Multiple default lookup namespaces may be set for the base class:

```ruby
Scope.namespaces << MyNamespace # => [nil, MyNamespace]
Scope.for MyModel               # => MyNamespace::MyScope
```

> [!TIP]
> Until a comprehensive documentation on all the use cases is released, the spec is recommended as further reading.
> One can access it by running `rake` in the gem directory.
> The output is quite descriptive to get familiar with the use cases.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Alexander-Senko/magic-lookup. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/Alexander-Senko/magic-lookup/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Magic Lookup project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Alexander-Senko/magic-lookup/blob/main/CODE_OF_CONDUCT.md).
