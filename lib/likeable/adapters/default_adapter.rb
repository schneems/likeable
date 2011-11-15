module Likeable
  module DefaultAdapter
    def self.cast_id
      lambda { |id| id.to_i }
    end

    def self.find_one
      lambda { |klass, id|
        klass.where(:id => id).first
      }
    end

    def self.find_many
      lambda { |klass, ids|
        klass.where(:id => ids)
      }
    end
  end
end
