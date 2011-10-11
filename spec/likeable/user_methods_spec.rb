require 'spec_helper'

class CleanTestClassForLikeable
  include Likeable
  def like_key
    "like_key"
  end

  def to_hash(*args); {} end

  def foo
  end

  def id
    @id ||= rand(100)
  end
end

Likeable.setup

describe Likeable::UserMethods do
  before(:each) do
    @user   = User.new
    @target = CleanTestClassForLikeable.new
  end

  describe '#like!' do
    it "calls add_like_from in target" do
      @target.should_receive(:add_like_from).with(@user)
      @user.like! @target
    end
  end

  describe '#unlike!' do
    it "calls remove_like_from in target" do
      @target.should_receive(:remove_like_from).with(@user)
      @user.unlike! @target
    end
  end

  describe '#like?' do
    it "calls liked_by? in target" do
      @target.should_receive(:liked_by?).with(@user)
      @user.like? @target
    end
  end

  describe '#like?' do
    it "calls liked_by? in target" do
      @target.should_receive(:liked_by?).with(@user)
      @user.like? @target
    end
  end

  describe '#friend_ids_that_like' do
     it "calls liked_friend_ids? in target" do
       @target.should_receive(:liked_friend_ids).with(@user)
       @user.friend_ids_that_like @target
     end
   end

   describe '#friends_that_like' do
      it "calls liked_friends? in target" do
        @target.should_receive(:liked_friends).with(@user, nil)
        @user.friends_that_like @target
      end
    end
end
