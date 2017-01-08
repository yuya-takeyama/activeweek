# ActiveWeek

ActiveSupport based Object Oriented API represents week

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activeweek', git: 'https://github.com/yuya-takeyama/activeweek.git'
```

And then execute:

    $ bundle

## Usage

### Get current week

```rb
require 'activeweek'

week = ActiveWeek::Week.current
```

### Get currenet week in specific timezone

```rb
week = Time.use_zone('Asia/Tokyo') { ActiveWeek::Week.current }
```

### Enumerate Date objects in the week

```rb
week.each_day { |date| p date }
```

### Traverse weeks

```rb
next_week = week.next_week
prev_week = week.prev_week
```

### Compare weeks

```rb
ActiveWeek::Week.new(2017, 1) == ActiveWeek::Week.new(2017, 1)
# => true

ActiveWeek::Week.new(2017, 2) < ActiveWeek::Week.new(2017, 1)
# => false
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Notice about Ruby 2.4/Rails 2.2

Currently this gem cannot work with Ruby 2.4 and Rails 2.2.

It'll be available after Rails 4.2.8 is released.  
See: https://github.com/rails/rails/pull/26334

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yuya-takeyama/activeweek.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
