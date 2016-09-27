# Calypso

Calypso is a unit test automater, developed for the ETA/OS project. It uses
a configuration file to automatically run all tests or specific tests based
on hardware or category.

Each test is specified in a JSON configuration file.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'calypso'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install calypso

## Usage

To run the calypso unit tests, type:

    $ calypso -c [configuration file]

If you want more in depth usage information issue the help command:

    $ calypso --help

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then,
run `rake spec` to run the tests. You can also run `bin/console` for an 
interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then
run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on [GitLab](https://git.bietje.net) at
https://git.bietje.net/etaos/calypso. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to
the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

