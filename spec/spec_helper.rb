# encoding: UTF-8
 require 'rubygems'
 require 'bundler'

 require 'rspec'
 require 'fluent/test'

 Dir["./lib/**/*.rb"].each{| f | require f}
