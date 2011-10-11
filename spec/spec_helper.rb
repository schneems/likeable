require 'rubygems'
require 'active_record'


$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../..', 'lib'))


def build_user!
  eval %Q{
      class User
        def id
          @time ||= Time.now.to_f.to_s
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

build_user!

require 'likeable'

require 'rspec'
require 'rspec/autorun'

