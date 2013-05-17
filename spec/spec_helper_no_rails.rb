# This file is intended for specs that do not depend on Rails and
# can therefore run much faster because they don't need Rails to boot.
# This is most helpful when running individual files or specs as when
# iterating on the implementation of a unit test.
#
# Rails-specific configurations have been commented.

# Adjust load path...
$LOAD_PATH.unshift File.expand_path('../app/models', File.dirname(__FILE__))

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  #config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  #config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  #config.infer_base_class_for_anonymous_controllers = false
end
