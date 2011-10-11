require 'spec_helper'


class LikeableIncludedInSetup

end

class SetupCleanTestClassForLikeable
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

describe Likeable do
  before(:each) do
    reload_user!
    Likeable.user_class = User
    @user   = User.new
    @target = SetupCleanTestClassForLikeable.new
  end


  describe "Likeable setup" do
    it "adds Likeable::UserMethods to User" do
      describe User.ancestors do
        it {should_not include Likeable::UserMethods}
      end
      Likeable.setup
      describe User.ancestors do
        it {should include Likeable::UserMethods}
      end
    end

    it "adds likeable to class" do
      Likeable.setup do |like|
        like.classes = LikeableIncludedInSetup
      end

      describe LikeableIncludedInSetup.ancestors do
        it {should include Likeable}
      end
    end

    it "" do
      result = "foo"
      Likeable.setup

      Likeable.after_like do |like|
        result = "after_like_called_successfully"
      end

      @user.like! @target
      result.should == "after_like_called_successfully"
    end
  end
end
