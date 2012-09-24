unless ENV['CI']
  require 'simplecov'
  SimpleCov.start do
    add_filter 'spec'
  end
end

require 'rspec'
require 'delayed_job_elastic_search'
require 'delayed/backend/shared_spec'

class Story
  include Tire::Model::Persistence
  property :text, :type => 'string', index: 'not_analyzed'
  def tell; text; end
  def whatever(n, _); tell*n; end
  def self.count; end

  handle_asynchronously :whatever
end
