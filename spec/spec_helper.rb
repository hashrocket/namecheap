begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end

require 'activesupport'
require 'activerecord'

$:.unshift(File.dirname(__FILE__) + '/../lib')
