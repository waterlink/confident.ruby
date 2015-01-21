# Confident.ruby

Be confident and narrative when writing code in ruby.

Gem contains useful abstractions for eliminating most condition and switch smells, treating anything just like a duck, implementing barricade and null object pattern efficiently.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'confident_ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install confident_ruby

## Usage

```ruby
require "confident"
```

### Eliminating condition

*Not implemented*

Given this code:

```ruby
class Order
  # ...  
  
  def charge
    if date < SEASON_START || date > SEASON_END
      quantity * normal_rate - discount
    else
      quantity * season_rate
    end
  end
  
  # ...
end
```

Becomes:

```ruby
class Order
  # ...
  
  def charge
    Charge.lift(date).for(quantity)
  end
  
  # ...
end
  
Charge = Confident::Liftable.build do
  lifts(to: :NormalCharge) { date < SEASON_START || date > SEASON_END }
  lifts(to: :SeasonCharge) { true }
  
  class NormalCharge < self
    def for(quantity)
      Money.lift(normal_rate) * quantity - Money.lift(discount)
    end
  end
  
  class SeasonCharge < self
    def for(quantity)
      Money.lift(season_rate) * quantity
    end
  end
end
```

### Eliminating switch

*Not implemented*

Given this code:

```ruby
class Product

  # ...

  def cost
    case kind
    when "hosting"
      hosting_cost
    when "dedicated"
      dedicated_cost
    when "virtual"
      virtual_cost
    else
      raise "Unreachable code"
    end
  end

  # ...

end
```

becomes:

```ruby
class Product

  # ...

  def cost
    kind.cost
  end

  def kind
    ProductKind.lift(@kind)
  end

  # ...

end

# could be abstracted even better, if the whole thing was in database source
ProductKind = Confident::Liftable.build do
  lift_map "hosting" => :HostingProductKind,
           "dedicated" => :DedicatedProductKind,
           "virtual" => :VirtualProductKind

  def cost
    Confident::Result.error("Unknown product kind")
  end

  class HostingProductKind < self
    def cost
      Confident::Result.ok(Money.lift(hosting_kind))
    end
  end

  class DedicatedProductKind < self
    def cost
      Confident::Result.ok(Money.lift(dedicated_kind))
    end
  end

  class VirtualProductKind < self
    def cost
      Confident::Result.ok(Money.lift(virtual_kind))
    end
  end
end
```

Looks like we expanding our code and making it bigger at no time, but it is actually beneficial to us, because we don't need to duplicate knowledge on how to determine `kind` of product throughout a codebase, we just call `Product.lift(kind_string_value)`, and we are done with it. You can implement this stuff in raw ruby easily, but this library wants to cut of a boilerplate code involved in this usually.

### Handling success/failure result

Just use `Confident::Result`:

```ruby
def some_computation_that_may_fail
  Confident::Result.ok(compute)
rescue => e
  Confident::Result.error(e.to_s)
end

puts some_computation_that_may_fail.on_error { |e| report_error(e) }.unwrap
```

If you have something that returns `true` in case of success and `false` in case of failure, you can use `Confident::Result.from_condition(boolean_value, failure_message=nil)`:

```ruby
Confident::Result.from_condition(some_weird_external_api, "Weird external API returned unexpected error")
```

### Pure null object

Pure null object (`Confident::NullObject`) quacks to any method with itself.

If you have an input value that could be `nil`, you can just wrap it in `Confident::AutoNullObject` to get either original value or pure null object if it is `nil`.
Example usage with `AutoNullObject`:

```ruby
def do_something_with(possibly_nil_value)
  AutoNullObject(some_possibly_nil_value).say("hello")
end

do_something_with(fetch_me_a_value)        # => "said: hello"
do_something_with(fetch_me_a_nil_value)    # => #<Confident::NullObject:0x000001019f37f8>
```

### TODO (to specify in this README)

- lift & bind
- null object with ability to define your own custom null object
- barricade

## Contributing

1. Fork it ( https://github.com/waterlink/confident.ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
