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

class LikeableIncludedInSetup
  def like_key
    "like_key"
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

  describe "module methods" do
    describe ".model" do
      it "takes a valid class string and turns it into a class" do
        klass = CleanTestClassForLikeable
        klass_name = klass.to_s
        Likeable.model(klass_name).should eq(klass)
      end
    end

    describe ".find_by_resource_id" do
      it "finds an active-record based object on a valid model and id" do
        klass = CleanTestClassForLikeable
        klass_name = klass.to_s
        id = rand(1000)
        klass.should_receive(:where).with(:id => id).and_return([])
        Likeable.find_by_resource_id(klass_name, id)
      end

      it "will return nil for an invalid object" do
        klass = CleanTestClassForLikeable
        klass_name = klass.to_s + "this makes this klass_name invalid"

        Likeable.find_by_resource_id(klass_name, rand(1000)).should be_blank
      end
    end

  end

end
