# encoding: utf-8
require 'delayed_job'
require 'tire'

module Tire::Model::Persistence
  class<<self
    alias old_included included
  end
  
  def self.included(base)
    old_included base
#    base.yaml_as 'tag:ruby.yaml.org,2002:ElasticSearch'
#    if YAML.parser.class.name =~ /syck/i    
#      def base.yaml_new(klass, tag, val)
#        klass.find(val['id']) || raise(Delayed::DeserializationError)
#      end
#    end
  end
  
#  unless YAML.parser.class.name =~ /syck/i    
#    def encode_with(coder)
#      coder['attributes'] = attributes
#      coder['klass'] = self.class
#    end
   
#    def init_with(coder, object=coder['klass'].find(coder['attributes']['id']))
#      raise(Delayed::DeserializationError) unless object
#      __update_attributes object.attributes
#    end
#  end
  
#  def to_yaml_properties
#    ['@attributes']
#  end  
end
