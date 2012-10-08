# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name              = 'delayed_job_elastic_search'
  s.summary           = "Elasticsearch backend for delayed_job"
  s.version           = '2.0.0'
  s.authors           = ['Nick Ricketts']
  s.email             = ['nightshade427@gmail.com']
  s.extra_rdoc_files  = ["LICENSE", "README.md"]
  s.files             = Dir.glob("{lib,spec}/**/*") + %w[LICENSE README.md]
  s.homepage          = 'http://github.com/nightshade427/delayed_job_elastic_search'
  s.rdoc_options      = ['--charset=UTF-8']
  s.require_paths     = ['lib']
  s.test_files        = Dir.glob('spec/**/*')

  s.add_dependency              'tire',        '~> 0.4'
  s.add_dependency              'delayed_job', '~> 3.0'
  s.add_development_dependency  'rspec',       '>= 2.0'
  s.add_development_dependency  'rake',        '>= 0.9'
  s.add_development_dependency  'simplecov',   '>= 0.6'
  s.add_development_dependency  'tzinfo',      '~> 0.3.3'  
end

