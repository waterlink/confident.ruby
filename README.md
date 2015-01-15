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

### Eliminating condition

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

### TODO (to specify in this README)

- switch smell
- lift & bind
- null object
- barricade

## Contributing

1. Fork it ( https://github.com/waterlink/confident.ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
