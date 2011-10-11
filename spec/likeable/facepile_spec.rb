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


describe Likeable::Facepile do
  before(:each) do
    @user   = User.new
    @target = CleanTestClassForLikeable.new
  end

  describe 'facepile' do
    before do
      @friend_ids = [1,2,3,4]
      @like_ids   = [3,4,5,6,7,8,9,10,11,12]
      @intersection = @friend_ids & @like_ids
    end
    describe '#ids_for_facepile' do
      it 'builds a array of ids with friend ids and randoms if they have liked the object up to the limit' do
        @target.should_receive(:liked_friend_ids).with(@user).and_return(@friend_ids)
        @target.should_receive(:like_user_ids).and_return(@like_ids)
        @target.ids_for_facepile(@user).should include(@intersection.sample)
      end

      it 'can be limited' do
        limit = 3
        @target.should_receive(:liked_friend_ids).and_return(@friend_ids)
        @target.should_receive(:like_user_ids).and_return(@like_ids)
        @target.ids_for_facepile(@user, limit).count.should eq(limit)
      end
    end

    describe '#users_for_facepile' do
      it 'builds a array of users if they have liked the object' do
        @target.should_receive(:ids_for_facepile).and_return(@friend_ids)
        User.should_receive(:where).with(:id => @friend_ids)
        @target.users_for_facepile(@user)
      end
    end

  end
end
