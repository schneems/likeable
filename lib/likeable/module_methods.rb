require 'redis'

module Likeable
  mattr_accessor :facepile_default_limit
  self.facepile_default_limit = 9


  ### Module Methods ###
  # ------------------ #
  class << self
    attr_writer :cast_id, :find_one, :find_many

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

      def adapter=(adapter)
        self.find_one  = adapter.find_one
        self.find_many = adapter.find_many
        @adapter = adapter
      end

      def cast_id(id)
        @cast_id ||= if @adapter && @adapter.respond_to?(:cast_id)
          @adapter.cast_id
        else
          DefaultAdapter.cast_id
        end
        @cast_id.call(id)
      end

      def find_many(klass, ids)
        @find_many ||= DefaultAdapter.find_many
        @find_many.call(klass, ids)
      end

      def find_one(klass, id)
        @find_one ||= DefaultAdapter.find_one
        @find_one.call(klass, id)
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
