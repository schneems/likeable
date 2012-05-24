require 'rubygems'
require 'active_record'
require 'singleton'
require 'tempfile'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../..', 'lib'))

require 'likeable'

module UserHelperMethods

  def build_user!
    eval %Q{
        class ::User
          include Likeable::UserMethods
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

end

RSpec.configure do |c|

  c.include UserHelperMethods

  c.treat_symbols_as_metadata_keys_with_true_values = true

  c.before :suite do
    Likeable.redis = NullRedis.new
  end

  c.before :each do
    build_user!
  end

  c.around :each, :integration do |example|
    IntegrationTestRedis.instance.start
    Likeable.redis = IntegrationTestRedis.instance.client
    Likeable.redis.flushdb
    example.run
    IntegrationTestRedis.instance.stop
    Likeable.redis = NullRedis.new
  end

end

class NullRedis

  def method_missing(*args)
    self
  end

  def to_s
    "Null Redis"
  end

end

class IntegrationTestRedis

  include ::Singleton

  PORT    = 9737
  PIDFILE = Tempfile.new('likeable-integration-test-redis-pid')

  def start
    install_at_exit_handler
    system("echo '#{options}' | redis-server -")
  end

  def stop
    system("if [ -e #{PIDFILE.path} ]; then kill -QUIT $(cat #{PIDFILE.path}) 2>/dev/null; fi")
  end

  def client
    return Redis.new(:port => PORT, :db => 15)
  end

  private

    def options
      {
        'daemonize'     => 'yes',
        'pidfile'       => PIDFILE.path,
        'bind'          => '127.0.0.1',
        'port'          => PORT,
        'timeout'       => 300,
        'dir'           => '/tmp',
        'loglevel'      => 'debug',
        'logfile'       => 'stdout',
        'databases'     => 16
      }.map { |k, v| "#{k} #{v}" }.join("\n")
    end

    def install_at_exit_handler
      at_exit {
        IntegrationTestRedis.instance.stop
      }
    end

end

class CleanTestClassForLikeable

  include Likeable

  def like_key
    "like_key"
  end

  def to_hash(*args);
    Hash.new
  end

  def foo
    nil
  end

  def id
    @id ||= rand(100)
  end

end
