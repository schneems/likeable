require 'active_support/concern'
require 'keytar'


module Likeable
  extend ActiveSupport::Concern

  included do
    include Keytar
    include Likeable::Facepile
    define_key :like, :key_case => nil

    if self.respond_to?(:after_destroy)
      after_destroy :destroy_all_likes
    else
      warn "#{self} doesn't support after_destroy callback, likes will not be cleared automatically when object is destroyed"
    end
  end

  def destroy_all_likes
    liked_users.each {|user| self.remove_like_from(user) }
  end

  # create a like
  # the user who created the like has a reference to the object liked
  def add_like_from(user, time = Time.now.to_f)
    Likeable.redis.hset(like_key, user.id, time)
    Likeable.redis.hset(user.like_key(self.class.to_s.downcase), self.id, time)
    like = Like.new(:target => self, :user => user, :time => time)
    after_like(like)
    clear_memoized_methods(:like_count, :like_user_ids, :liked_user_ids, :liked_users, :likes)
    like
  end

  def clear_memoized_methods(*methods)
    methods.each do |method|
      eval("@#{method} = nil")
    end
  end

  def after_like(like)
    Likeable.after_like.call(like)
  end

  # removes a like
  def remove_like_from(user)
    Likeable.redis.hdel(like_key, user.id)
    Likeable.redis.hdel(user.like_key(self.class.to_s.downcase), self.id)
    clear_memoized_methods(:like_count, :like_user_ids, :liked_user_ids, :liked_users)
  end

  def like_count
    @like_count ||= @like_user_ids.try(:count) || @likes.try(:count) || Likeable.redis.hlen(like_key)
  end

  # get all user ids that have liked a target object
  def like_user_ids
    @like_user_ids ||= (Likeable.redis.hkeys(like_key)||[]).map(&:to_i)
  end

  def liked_users(limit = nil)
    @liked_users ||= User.where(:id => like_user_ids)
  end

  def likes
    @likes ||= begin
      Likeable.redis.hgetall(like_key).collect do |user_id, time|
        Like.new(:user_id => user_id, :time => time, :target => self)
      end
    end
  end

  # did given user like the object
  def liked_by?(user)
    return false unless user
    liked_by =    @like_user_ids.include?(user.id) if @like_user_ids
    liked_by ||=  Likeable.redis.hexists(like_key, user.id)
  end


  def likeable_resource_name
    Likeable.get_resource_name_for_class(self.class)
  end


  ### Class Methods ###
  # ----------------- #
  # allows us to setup callbacks when creating likes
  # after_like :notify_users
  module ClassMethods

    def all_liked_ids_by(user)
      key = user.like_key(self.to_s.downcase)
      ids = (Likeable.redis.hkeys(key)||[]).map(&:to_i)
    end

    def all_liked_by(user)
      ids = all_liked_ids_by(user)
      self.where(:id => ids)
    end

    def after_like(*methods)
      define_method(:after_like) do |like|
        methods.each do |method|
          eval("#{method}(like)")
        end
      end
    end
  end
end

require 'likeable/like'
require 'likeable/facepile'
require 'likeable/user_methods'
require 'likeable/module_methods'
