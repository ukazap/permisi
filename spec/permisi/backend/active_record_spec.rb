# frozen_string_literal: true

require "spec_helper"

RSpec.describe Permisi::Backend::ActiveRecord do
  it "has backend interfaces" do
    expect(described_class.respond_to?(:findsert_actor)).to be true
    expect(described_class.respond_to?(:actors)).to be true
    expect(described_class.respond_to?(:roles)).to be true
  end

  describe Permisi::Backend::ActiveRecord::Actor do
    subject { described_class.new }

    it "has actor interfaces" do
      expect(subject.respond_to?(:has_role?)).to be true
      expect(subject.respond_to?(:may?)).to be true
      expect(subject.respond_to?(:may_i?)).to be true
    end
  end

  describe Permisi::Backend::ActiveRecord::Role do
    subject { described_class.new }

    it "has role interfaces" do
      expect(subject.respond_to?(:allows?)).to be true
    end
  end

  describe "cache invalidation" do
    context "creating an actor" do
      let(:aka) { User.create! }
      let!(:old_aka_cache_key) { aka.cache_key }

      it "updates the aka" do
        actor = Permisi::Backend::ActiveRecord::Actor.create!(aka: aka)
        expect(old_aka_cache_key).not_to eq aka.cache_key
      end
    end

    context "adding roles to an actor" do
      let(:aka) { User.create!(name: "Esther") }
      let(:actor) { Permisi::Backend::ActiveRecord::Actor.create!(aka: aka) }
      let(:role) { Permisi::Backend::ActiveRecord::Role.create!(slug: :admin) }

      it "updates the actor" do
        old_actor_cache_key = actor.cache_key
        old_aka_cache_key = actor.aka.cache_key
        expect(actor.reload.roles).to be_empty
        actor.roles << role
        expect(actor.reload.roles).not_to be_empty
        expect(old_actor_cache_key).not_to eq actor.cache_key
        expect(old_aka_cache_key).not_to eq actor.aka.cache_key
      end
    end

    context "removing roles from an actor" do
      let(:aka) { User.create!(name: "Bintang") }
      let(:actor) { Permisi::Backend::ActiveRecord::Actor.create!(aka: aka) }
      let(:role) { Permisi::Backend::ActiveRecord::Role.create!(slug: :casserole) }

      it "updates the actor" do
        actor.roles << role

        old_actor_cache_key = actor.cache_key
        old_aka_cache_key = actor.aka.cache_key
        expect(actor.reload.roles).not_to be_empty
        actor.roles.destroy(role)
        expect(actor.reload.roles).to be_empty
        expect(old_actor_cache_key).not_to eq actor.cache_key
        expect(old_aka_cache_key).not_to eq actor.aka.cache_key
      end
    end

    context "updating/destroying roles" do
      let(:aka_one) { User.create!(name: "Esther") }
      let(:aka_two) { User.create!(name: "Bintang") }
      let(:actor_one) { Permisi::Backend::ActiveRecord::Actor.create!(aka: aka_one) }
      let(:actor_two) { Permisi::Backend::ActiveRecord::Actor.create!(aka: aka_two) }
      let(:role_one) { Permisi::Backend::ActiveRecord::Role.create!(slug: :mgmt) }
      let(:role_two) { Permisi::Backend::ActiveRecord::Role.create!(slug: :guests) }

      it "updates the actors" do
        actor_one.roles += [role_one, role_two]
        actor_two.roles += [role_one, role_two]

        old_cache_keys = [
          actor_one.reload.cache_key,
          actor_two.reload.cache_key
        ]

        role_one.update!(slug: :managements)

        expect(old_cache_keys).not_to eq [
          actor_one.reload.cache_key,
          actor_two.reload.cache_key
        ]

        old_cache_keys = [
          actor_one.reload.cache_key,
          actor_two.reload.cache_key
        ]

        role_two.destroy!

        expect(old_cache_keys).not_to eq [
          actor_one.reload.cache_key,
          actor_two.reload.cache_key
        ]
      end
    end
  end
end
