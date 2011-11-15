require 'spec_helper'

describe Likeable::OhmAdapter do
  let(:klass) { Class.new }

  before do
    Likeable.adapter = Likeable::OhmAdapter
  end

  after do
    default_adapter!
  end

  it "finds one by passing the id to find" do
    klass.should_receive(:[]).with(42)
    Likeable.find_one(klass, 42)
  end

  it "finds many by passing the ids array find" do
    klass.should_receive(:[]).with(1).ordered
    klass.should_receive(:[]).with(42).ordered
    Likeable.find_many(klass, [1, 42])
  end
end
