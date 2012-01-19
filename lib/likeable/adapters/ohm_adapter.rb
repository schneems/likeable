module Likeable
  module OhmAdapter
    def self.find_one
      lambda { |klass, id|
        klass[id]
      }
    end

    def self.find_many
      lambda { |klass, ids|
        Array(ids).collect do |id|
          klass[id]
        end.compact
      }
    end
  end
end
