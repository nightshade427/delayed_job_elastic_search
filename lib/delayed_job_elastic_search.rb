# encoding: utf-8
require 'delayed/backend/elastic_search'
require 'delayed/serialization/elastic_search'
require 'delayed_job'

Delayed::Worker.backend = :elastic_search

Delayed::Backend::ElasticSearch::Job.delete_all