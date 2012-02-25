# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'hipaarails/version'
require 'date'

Gem::Specification.new do |s|
  s.name    = 'hipaarails'
  s.version = HIPAARails::Version.string
  s.date    = Date.today

  s.summary     = 'HIPAA compliance in Rails applications'
  s.description = 'Allows Rails applications to easily encrypt' +
      'protected health information (PHI) and audit accesses'

  s.author   = 'Anirudh Ramachandran'
  s.email    = 'anirudhvr@gmail.com'
  s.homepage = 'http://github.com/oakenshield/hipaarails'
  s.signing_key = '/home/ubuntu/.ssh/gem-private_key.pem'
  s.cert_chain = ['gem-public_cert.pem']

  s.has_rdoc = false
  s.rdoc_options = ['--line-numbers', '--inline-source', '--main', 'README.rdoc']

  s.require_paths = ['lib']
  
  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.add_dependency('attr_encrypted', ['~> 1.2.0'])
  s.add_dependency('paper_trail', ['~> 2.6.0'])
  s.add_development_dependency('activerecord', ['>= 2.0.0'])
  s.add_development_dependency('datamapper')
  s.add_development_dependency('mocha')
  s.add_development_dependency('sequel')
  s.add_development_dependency('dm-sqlite-adapter')
  s.add_development_dependency('sqlite3')
end
