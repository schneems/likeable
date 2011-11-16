module Likeable::UserMethods
  extend ActiveSupport::Concern

  included do
    include Keytar
    define_key :like, :key_case => nil
    define_key :dislike, :key_case => nil
  end

  # Add a like to an object
  # if already disliked, remove the dislike and add a like.
  def like!(obj)
    obj.remove_dislike_from(self)
    obj.add_like_from(self)
  end

  # Add a Dislike to an object
  # if already liked, remove the like and add a dislike.
  def dislike!(obj)
    obj.remove_like_from(self)
    obj.add_dislike_from(self)
  end

  # Remove both like or dislike by the Likeable.user_class
  def cancel_like!(obj)
    obj.remove_like_from(self)
    obj.remove_dislike_from(self)
  end

  def like?(obj)
    obj.liked_by?(self)
  end
  alias :likes? :like?

  def dislike?(obj)
    obj.disliked_by?(self)
  end
  alias :dislikes? :dislike?

  def friend_ids_that_like(obj)
    obj.liked_friend_ids(self)
  end

  def friend_ids_that_dislike(obj)
    obj.disliked_friend_ids(self)
  end

  def friends_that_like(obj, limit = nil)
    obj.liked_friends(self, limit)
  end

  def friends_that_dislike(obj, limit = nil)
    obj.disliked_friends(self, limit)
  end

  # @user.liked(Spot)
  #   will return all spots that user has liked
  def all_liked(klass)
    klass.all_liked_by(self)
  end

  def all_disliked(klass)
    klass.all_disliked_by(self)
  end
end