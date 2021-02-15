require "spec_helper"

RSpec.describe Permisi::Actable do
  before(:each) do
    allow(Permisi.config).to receive(:backend) { DummyBackend }
    @object = Object.new
    @object.extend(described_class)
  end

  describe "#permisi" do
    it "returns an actor" do
      expect(@object.permisi_actor).to be_a DummyBackend::Actor
    end
  end
end
