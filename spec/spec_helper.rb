require 'rubygems'
require 'active_record'


$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../..', 'lib'))


def build_user!
  eval %Q{
      class User
        def id
          @time ||= Time.now.to_f.to_s.tr('.', '').to_i
        end

        def self.where(*args)
        end

        def friends_ids
          []
        end

        def self.after_destroy
        end
      end
    }
end

def unload_user!
  Object.instance_eval{ remove_const :User }
end

def reload_user!
  unload_user!
  build_user!
end

def default_adapter!
  Likeable.adapter = Likeable::DefaultAdapter
end

build_user!

require 'likeable'

require 'tempfile'
require 'rspec'
require 'rspec/autorun'

RSpec.configure do |config|
  REDIS_PIDFILE = Tempfile.new("likeable-redis")

  config.before(:suite) do
    redis_options = {
      "daemonize"     => 'yes',
      "pidfile"       => REDIS_PIDFILE.path,
      "bind"          => "127.0.0.1",
      "port"          => 9737,
      "timeout"       => 300,
      "dir"           => "/tmp",
      "loglevel"      => "debug",
      "logfile"       => "stdout",
      "databases"     => 16
    }.map { |k, v| "#{k} #{v}" }.join('\n')
    `echo '#{redis_options}' | redis-server -`

    $redis_test_connection = Redis.new(:port => 9737, :db => 15)
  end

  config.before(:each) do
    default_adapter!
    $redis_test_connection.flushdb
    Redis.stub(:new).and_return($redis_test_connection)
  end

  # TODO this needs to handle premature exits, too
  config.after(:suite) do
    %x{
      cat #{REDIS_PIDFILE.path} | xargs kill -QUIT
    }
  end
end
