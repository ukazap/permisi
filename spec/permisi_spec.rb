# frozen_string_literal: true

RSpec.describe Permisi do
  it "has a version number" do
    expect(Permisi::VERSION).not_to be nil
  end

  describe ".init" do
    it "initializes the gem" do
      Permisi.init { |config| config.permissions = { a: [:b] } }
      expect(Permisi.config.permissions).to eq HashWithIndifferentAccess.new({ a: [:b] })
    end
  end

  describe ".actor" do
    it "find an actor or create it if doesn't already exist" do
      DummyBackend.reset
      allow(Permisi.config).to receive(:backend) { DummyBackend }

      aka = Struct.new(:name).new("Esther")

      expect(Permisi.actors).to be_empty

      actor = Permisi.actor(aka)
      expect(actor).to be_a Permisi.config.backend::Actor

      expect(Permisi.actors).not_to be_empty
    end
  end

  describe ".actors" do
    it "returns actors" do
      DummyBackend.reset
      allow(Permisi.config).to receive(:backend) { DummyBackend }
      expect(Permisi.actors).to eq([])
    end
  end

  describe ".roles" do
    it "returns roles" do
      DummyBackend.reset
      allow(Permisi.config).to receive(:backend) { DummyBackend }
      expect(Permisi.roles).to eq([])
    end
  end
end
