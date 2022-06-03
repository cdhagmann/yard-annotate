## yarn-annotate [![Build Status](https://travis-ci.com/camertron/yarn-annotate.svg?branch=master)](https://travis-ci.com/camertron/yarn-annotate)

Automatically annotate your code with Sorbet type definitions.

## What is This Thing?

The wonderful folks at Stripe recently released a static type checker for Ruby called [Sorbet](https://github.com/sorbet/sorbet). It works by examining type signatures placed at the beginning of each method. For example:

```ruby
# typed: true

class Car
  extend T::Sig

  sig { params(num_wheels: Integer) }
  def initialize(num_wheels)
    @num_wheels = num_wheels
  end

  sig { params(speed: Float).returns(T::Boolean) }
  def drive(speed)
    true
  end
end
```

Adding these definitions means you get cool stuff like auto-complete and type checking in your editor. Pretty freaking rad.

### Ok, so what is YarnAnnotate?

YarnAnnotate is an _auto_-matic way (get it?! lol) of adding Sorbet type signatures to your methods. It works by running your code (for example, your test suite). As your code runs, YarnAnnotate keeps track of the actual types of objects that were passed to your methods as well as the types of objects they return. After gathering the info, YarnAnnotate then (optionally) inserts type signatures into your Ruby files.

## Installation

`gem install yarn-annotate`

## Usage

You can run YarnAnnotate either via the command line or by adding it to your bundle.

### Command Line Usage

First, install the gem by running `gem install yarn-annotate`. That will make the `yarn-annotate` executable available on your system.

YarnAnnotate's only subcommand is `run`, which accepts a list of Ruby files to scan for methods and a command to run that will exercise your code.

In this example, we're going to be running an [RSpec](https://github.com/rspec/rspec) test suite.
Like most RSpec test suites, let's assume ours is stored in the `spec/` directory (that's the RSpec default too). To run the test suite in `spec/` and add type definitions to our ruby files, we might run the following command:

```bash
yarn-annotate run --annotate $(find . -name '*.rb') -- bundle exec rspec spec/
```

You can also choose to run YarnAnnotate with the `--rbi` flag, which will cause YarnAnnotate to print results to standard output or to the given file in [RBI format](https://sorbet.org/docs/rbi):

```bash
# print RBI output to STDOUT
yarn-annotate run --annotate --rbi - $(find . -name '*.rb') -- bundle exec rspec spec/

# write RBI output to a file
yarn-annotate run --annotate --rbi ./rbi/mylib.rbi $(find . -name '*.rb') -- bundle exec rspec spec/
```

In this second example, we're going to be running a minitest test suite. Like most minitest suites, let's assume ours is stored in the `test/` directory (that's the Rails default too). To run the test suite in `test/`, we might run the following command:

```bash
yarn-annotate run --annotate $(find . -name '*.rb') -- bundle exec rake test/
```

### YarnAnnotate in your Bundle

If you would rather run YarnAnnotate as part of your bundle, add it to your Gemfile like so:

```ruby
gem 'yarn-annotate'
```

YarnAnnotate can be invoked from within your code in one of several ways.

#### YarnAnnotate.discover

Wrap code you'd like to run with YarnAnnotate in `YarnAnnotate.discover`:

```ruby
require 'yarn-annotate'

YarnAnnotate.paths << 'path/to/file/i/want/to/annotate.rb'

YarnAnnotate.discover do
  call_some_method(with, some, params)
end

# loop over files and annotate them
YarnAnnotate.each_absolute_path do |path|
  YarnAnnotate.annotate_file(path)
end

# you can also grab a reference to the method cache YarnAnnotate
# has populated with all the type information it's been able
# to gather:
YarnAnnotate.method_index
```

#### Setup and Teardown

`YarnAnnotate.discover` is just syntactic sugar around two methods that start and stop YarnAnnotate's method tracing functionality:

```ruby
YarnAnnotate.setup

begin
  call_some_method(with, some, params)
ensure
  YarnAnnotate.teardown
end
```

#### RSpec Helper

YarnAnnotate comes with a handy RSpec helper that can do most of this for you. Simply add

```ruby
require 'yarn_annotate/rspec'
```

to your spec_helper.rb, Rakefile, or wherever RSpec is configured. You'll also need to set the `YARN_ANNOTATE_FILES` environment variable when running your test suite. For example:

```bash
YARN_ANNOTATE_FILES=$(find . -name *.rb) bundle exec rspec
```

Files can be separated by spaces, newlines, or commas. If you want YarnAnnotate to annotate them, set `YARN_ANNOTATE_ANNOTATE` to `true`, eg:

```bash
YARN_ANNOTATE_FILES=$(find . -name *.rb) YARN_ANNOTATE_ANNOTATE=true bundle exec rspec
```

Finally, set `YARN_ANNOTATE_RBI=/path/to/output.rbi` to have YarnAnnotate emit an RBI file when the test suite finishes.

## How does it Work?

YarnAnnotate makes use of Ruby's [TracePoint API](https://ruby-doc.org/core-2.6/TracePoint.html). TracePoint effectively allows YarnAnnotate to receive a notification whenever a Ruby method is called and whenever a method returns. That info combined with method location information gathered from parsing your Ruby files ahead of time allows YarnAnnotate to know a) where methods are located, 2) what arguments they take, 3) the types of those arguments, and 4) the type of the return value.

"Doesn't that potentially make my code run slower?" is a question you might ask. Yes. YarnAnnotate adds overhead to literally every Ruby method call, so your code will probably run quite a bit slower. For that reason you probably won't want to enable YarnAnnotate in, for example, a production web application.

## Known Limitations

* Half-baked support for singleton (i.e. static) methods.
* YarnAnnotate does not annotate Ruby files with `# typed: true` comments or `extend T::Sig`.

## Running Tests

`bundle exec rspec` should do the trick :)

## Contributing

Please fork this repo and submit a pull request.

## License

Licensed under the MIT license. See LICENSE for details.

## Authors

* Cameron C. Dutro: http://github.com/camertron
