require 'spec_helper'
describe Likeable::Like do
  before do
    @time = Time.now
  end
  describe 'attributes' do
    it 'stores target, user, and created_at' do
      like = Likeable::Like.new(:target => @target, :user => @user, :time => @time)
      like.user.should        eq(@user)
      like.target.should      eq(@target)
      like.created_at.should  eq(@time)
    end

    it 'converts float time to propper Time object' do
      like = Likeable::Like.new(:time => @time.to_f)
      like.created_at.should eq(@time)
    end
  end
end
