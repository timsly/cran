require 'rspec/its'
require 'rspec/collection_matchers'

RSpec.configure do |config|
  config.order = 'random'

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
