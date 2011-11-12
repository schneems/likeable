module Likeable
  module DefaultAdapter
    def self.find_one
      lambda { |klass, id|
        klass.where(:id => id)
      }
    end

    def self.find_many
      lambda { |klass, ids|
        klass.where(:id => ids)
      }
    end
  end
end
