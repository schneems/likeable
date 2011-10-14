require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "likeable"
  gem.homepage = "https://github.com/schneems/Likeable"
  gem.license = "MIT"
  gem.summary = %Q{Like ruby objects backed by redis}
  gem.description = %Q{
    Likeable allows you to make your models...well...likeable using redis.
  }
  gem.email = "richard.schneeman@gmail.com"
  gem.authors = ["Schneems"]
  gem.add_development_dependency "rspec"
end
Jeweler::RubygemsDotOrgTasks.new
