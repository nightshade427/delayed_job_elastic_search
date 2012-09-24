# delayed_job ElasticSearch backend

## Requirements

Make sure you are using Tire version 0.4 or newer.


## Installation

Add the gem to your Gemfile:

    gem 'delayed_job_elasticsearch'

After running `bundle install`, create the indexes (and don't forget to do this on your production database):

    script/rails runner 'Delayed::Backend::ElasticSearch::Job.create_elasticsearch_index'

That's it. Use [delayed_job as normal](http://github.com/collectiveidea/delayed_job).
