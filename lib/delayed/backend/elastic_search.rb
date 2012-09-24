# encoding: utf-8
require 'delayed_job'
require 'tire'

module Delayed
  module Backend
    module ElasticSearch
      class Job
        include Tire::Model::Persistence
        include Delayed::Backend::Base
        index_name 'jobs'
        PERPAGE = 9999999
        
        property :locked_at,  :type => 'date'
        property :failed_at,  :type => 'date'       
        property :priority,   :type => 'integer', default: 0
        property :attempts,   :type => 'integer', default: 0        
        property :queue,      :type => 'string', index: 'not_analyzed'        
        property :handler,    :type => 'string', index: 'not_analyzed'
        property :locked_by,  :type => 'string', index: 'not_analyzed'
        property :last_error, :type => 'string', index: 'not_analyzed'        
        property :run_at,     :type => 'date'
        after_update_elasticsearch_index Proc.new{ index.refresh }

        def initialize(attributes={})
          super.tap{ setup_defaults }
        end
        
        def ==(other)
          id == other.id
        end
        
        def reload
          __update_attributes(self.class.find(id).attributes) and reset
          self
        end   
        
        def freeze
          attributes.freeze
          self
        end   
        
        def save!
          raise 'no workie' unless save
        end  
        
        def self.db_time_now
          Time.now.utc
        end
        
        def self.delete_all
          index.delete and create_elasticsearch_index
          sleep 0.1
        end
        
        def self.create!(attributes, object=create(attributes))
          raise 'no workie' unless object
          object
        end
        
        def self.count
          search(per_page:0){query{all}}.total
        end
        
        def self.enqueue(*args)
          raise ArgumentError, 'Jobs cannot be created for records before they\'ve been persisted' if unpersisted_performable?(args)
          super
        end

        def self.reserve(worker, max_run_time=Worker.max_run_time, right_now=db_time_now)
          jobs = find_available(worker.name, worker.read_ahead, max_run_time)
                  .each{ |job| job.update_attributes locked_at: right_now, locked_by: worker.name }
          jobs.empty? ? nil : jobs.first
        end
        
        def self.find_available(worker_name, limit=5, max_run_time=Worker.max_run_time, right_now=db_time_now)
          search(per_page:limit) do |s|
            s.query do |q|
              q.filtered do |fq|
                fq.query{ |rq| rq.range :run_at, lte: right_now }
                fq.filter :and, filters(worker_name, max_run_time, right_now)
              end
            end
            s.sort{ by(:locked_by, :desc); by(:priority, :asc); by(:run_at, :asc) }
          end
        end

        def self.clear_locks!(worker_name)
          find_by_worker_name(worker_name).each{ |job| job.update_attributes :locked_at => nil, :locked_by => nil }
        end
        
        private
        def self.find_by_worker_name(name)
          search(per_page:PERPAGE){ |s| s.query{ |q| q.term :locked_by, name } }
        end
        
        def self.filters(worker_name, max_run_time, right_now)
          filters = [{missing:{field: :failed_at}}]
          filters << {or: [{missing:{field: :locked_at}}, {term:{locked_by: worker_name}}, range:{locked_at:{lte: right_now-max_run_time}}]}
          filters << {range:{priority:{gte: Worker.min_priority.to_i}}} if Worker.min_priority
          filters << {range:{priority:{lte: Worker.max_priority.to_i}}} if Worker.max_priority
          filters << {terms:{queue: Worker.queues}} unless Worker.queues.empty?
          filters
        end
        
        def setup_defaults
          self.run_at ||= self.class.db_time_now
        end
        
        def self.unpersisted_performable?(args)
          args.first.is_a?(Hash) && args.first[:payload_object].is_a?(PerformableMethod) && !args.first[:payload_object].object.persisted?
        end
      end
    end
  end
end