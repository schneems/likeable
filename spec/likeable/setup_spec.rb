require 'spec_helper'


describe Likeable do
  describe "setup" do
    context "when the User class is defined" do
      before(:each) do
        reload_user!
        Likeable.user_class = User
        @user   = User.new
        @target = CleanTestClassForLikeable.new
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

    context "when the User class doesn't exist" do
      before do
        # Need a cleaner way to do this, but the setter
        # prevents it
        Likeable.instance_variable_set(:@user_class, nil)
        unload_user!
      end

      after do
        build_user!
        Likeable.setup
      end

      it "won't raise an exception" do
        lambda { Likeable.setup }.should_not raise_error
      end
    end
  end
end
