module Likeable
  module MongoidAdapter
    def self.cast_id
      lambda { |id| id.to_s }
    end

    def self.find_one
      lambda { |klass, id|
        klass.find id
      }
    end

    def self.find_many
      lambda { |klass, ids|
        klass.find ids
      }
    end
  end
end
