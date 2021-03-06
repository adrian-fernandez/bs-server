require 'simplecov'

SimpleCov.start do
  add_filter '/test/'
  add_filter '/config/'
  add_filter '/spec'
  add_filter '/spec'
  # add_filter '/app/controllers/concerns/authentication.rb'
  # add_filter '/app/controllers/concerns/authorization.rb'

  add_group 'Models', 'app/models'
  add_group 'Helpers', 'app/helpers'
  add_group 'Libraries', 'lib'
  add_group 'Services', 'app/services/'
  add_group 'Policies', 'app/policies/'
  add_group 'Decorators', 'app/decoratos/'
  add_group 'Jobs', 'app/jobs/'
end

RSpec.configure do |config|
  # These two settings work together to allow you to limit a spec run
  # to individual examples or groups you care about by tagging them with
  # `:focus` metadata. When nothing is tagged with `:focus`, all examples
  # get run.
  config.run_all_when_everything_filtered = true

  # Many RSpec users commonly either run the entire suite or an individual
  # file, and it's useful to allow more verbose output when running an
  # individual spec file.
  if config.files_to_run.one?
    # Use the documentation formatter for detailed output,
    # unless a formatter has already been configured
    # (e.g. via a command-line flag).
    config.default_formatter = 'doc'
  end

  # Print the 10 slowest examples and example groups at the
  # end of the spec run, to help surface which specs are running
  # particularly slow.
  config.profile_examples = 100

  config.fail_fast = false

  # Run specs in random order to surface order dependencies.
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  Kernel.srand config.seed

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect

    # Prevents you from mocking or stubbing a method that
    # does not exist on a real object.
    mocks.verify_partial_doubles = true
  end
end
