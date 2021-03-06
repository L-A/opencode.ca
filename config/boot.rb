# Bundler setup
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)
require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
Bundler.require(:default, ENV['RACK_ENV']) if defined? Bundler

# Since we can't require multiple files in Gemfile,
# it's cleaner to require them here (even if there
# is currently just one)
require 'sinatra/json'

# Require models
Dir[File.expand_path('../../app/models/**/*.rb', __FILE__)].each do |file|
  dirname = File.dirname(file)
  file_basename = File.basename(file, File.extname(file))
  require "#{dirname}/#{file_basename}"
end

# Application setup
ENV['CANONICAL_HOST'] ||= ENV['RACK_ENV'] == 'development' ? '0.0.0.0' : 'opencode.ca'
require File.expand_path('../../app/apps/application',  __FILE__)
require File.expand_path('../../app/apps/api',  __FILE__)
require File.expand_path('../../app/apps/easter_egg',  __FILE__)
