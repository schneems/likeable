require 'redis'

module Likeable
  mattr_accessor :facepile_default_limit
  self.facepile_default_limit = 9


  ### Module Methods ###
  # ------------------ #
  class << self
    def classes
      (@classes||[]).flatten
    end

    def classes=(*args)
      @classes = args
    end

      # Likeable.model("Highlight")
      # ------------------------- #
      # turns a string into a model
      # "Highlight".constantize # => Highlight; "Hi1i6ht".constantize = #=> false
      def model(target_model)
        target_model.camelcase.constantize
      rescue NameError => ex
        return false
      end

      # Likeable.find_by_resource_id("highlight", 22)
      # ---------------------------------------- #
      # #<Highlight id: ... # if highlight 22 exists
      # nil                 # if highlight 22 does not exist
      def find_by_resource_id(resource_name, target_id)
        target = Likeable.get_class_for_resource_name(resource_name)
        if target.present?
          Likeable.find_one(target, target_id)
        else
          false
        end
      end

      # Likeable.get_class_for_resource_name('photo')
      # ------------------------- #
      # Returns the class for the resource name
      def get_class_for_resource_name(resource_name)
        self.model(resource_name)
      end

      def get_resource_name_for_class(klass)
        klass
      end

      def redis
        @redis ||= Redis.new
      end

      def redis=(redis)
        @redis = redis
      end

      def after_like(&block)
        @after_like = block if block.present?
        @after_like ||= lambda {|like|}
        @after_like
      end

      def after_unlike(&block)
        @after_unlike = block if block.present?
        @after_unlike ||= lambda {|unlike|}
        @after_unlike
      end

      def find_many=(find_many)
        @find_many = find_many
      end

      def find_many(klass, ids)
        @find_many ||= lambda {|klass, ids| klass.where(:id => ids)}
        @find_many.call(klass, ids)
      end


      def find_one(klass, id)
        @find_one ||= lambda {|klass, ids| klass.where(:id => id).first}
        @find_one.call(klass, id)
      end

      def find_one=(find_one)
        @find_one = find_one
      end

      def user_class
        begin
          @user_class ||= ::User
        rescue NameError
          nil
        end
      end

      def user_class=(klass)
        raise ArgumentError, "Argument must be a class" unless klass.is_a?(Class)
        @user_class = klass
      end

      # Likeable.setup do |like|
      #  like.redis     = Redis.new(#...)
      #  like.find_one  = lambda {|klass, id | klass.where(:id => id)}
      #  like.find_many = lambda {|klass, ids| klass.where(:id => ids)}
      # end
      def setup(&block)
        yield self unless block.blank?
        true
      end
    end
end
