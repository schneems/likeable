module Likeable
  module Facepile
    # returns friend of user who like target
    def liked_friends(user, limit = nil)
      friend_ids = liked_friend_ids(user)
      friend_ids = friend_ids.sample(limit) unless limit.blank?
      @liked_friends ||= Likeable.find_many(User, friend_ids)
    end

    def liked_friend_ids(user)
      @liked_friend_ids ||= like_user_ids & user.friend_ids
    end

    def ids_for_facepile(user, limit = Likeable.facepile_default_limit)
      ids = liked_friend_ids(user).shuffle + like_user_ids.shuffle # show friends first
      ids.uniq.first(limit)
    end

    def users_for_facepile(user, limit = Likeable.facepile_default_limit)
      return [] if user.blank?
      @facepile ||= begin
        return nil unless ids = ids_for_facepile(user, limit)
        Likeable.find_many(User, ids)
      end
    end
  end
end