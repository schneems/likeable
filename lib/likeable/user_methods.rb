module Likeable::UserMethods
  extend ActiveSupport::Concern

  included do
    include Keytar
    define_key :like, :key_case => nil
  end


  def like!(obj)
    obj.add_like_from(self)
  end

  def unlike!(obj)
    obj.remove_like_from(self)
  end

  def like?(obj)
    obj.liked_by?(self)
  end
  alias :likes? :like?

  def friend_ids_that_like(obj)
    obj.liked_friend_ids(self)
  end

  def friends_that_like(obj, limit = nil)
    obj.liked_friends(self, limit)
  end

  # @user.liked(Spot)
  #   will return all spots that user has liked
  def all_liked(klass)
    klass.all_liked_by(self)
  end
end