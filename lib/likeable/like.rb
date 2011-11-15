require 'digest/sha1'

class Likeable::Like
  attr_accessor :created_at, :target, :like_user, :user_id

  def initialize(options = {})
    self.created_at = Time.at(options[:time].try(:to_f)||Time.now)
    self.target     = options[:target]
    self.user_id    = options[:user].try(:id) || options[:user_id]
    self.like_user  = options[:user]
  end

  def id
    Digest::SHA1.hexdigest("#{user_id}#{target.class}#{target.id}#{created_at}")
  end

  def user
    @user ||= like_user
    @user ||= Likeable.find_one(User, user_id)
    @user
  end

  def to_hash(type=:full)
    {
      :created_at => created_at.iso8601,
      :type       => target.class.name.gsub(/^[A-Za-z]+::/, '').underscore.downcase.to_sym,
      :target     => target.to_hash(type),
      :user       => user.to_hash(type)
    }
  end
end
