# frozen_string_literal: true

require "spec_helper"

RSpec.describe Permisi::Backend::ActiveRecord::Actor do
  subject { described_class.new }

  it "has actor interfaces" do
    expect(subject.respond_to?(:has_role?)).to be true
    expect(subject.respond_to?(:may?)).to be true
    expect(subject.respond_to?(:may_i?)).to be true
  end

  describe "#may_i?" do
    let(:actor) { Permisi::Backend::ActiveRecord::Actor.create!(aka: User.create!(name: "Esther")) }

    let(:companion_role) do
      Permisi::Backend::ActiveRecord::Role.create!(slug: :companion, permissions: {
        tardis: {
          enter: true,
          steer: false
        }
      })
    end

    let(:timelord_role) do
      Permisi::Backend::ActiveRecord::Role.create!(slug: :timelord, permissions: {
        tardis: {
          enter: true,
          steer: true
        }
      })
    end

    it "returns whether the actor is allowed to perform an action" do
      allow(Permisi.config).to receive(:default_permissions) do
        HashWithIndifferentAccess.new({ tardis: { enter: false, steer: false } })
      end

      actor.roles << companion_role
      expect(actor.may_i?("tardis.enter")).to be true
      expect(actor.may_i?("tardis.steer")).to be false

      actor.roles << timelord_role
      expect(actor.may_i?("tardis.enter")).to be true
      expect(actor.may_i?("tardis.steer")).to be true

      actor.roles.destroy(companion_role)
      expect(actor.may_i?("tardis.enter")).to be true
      expect(actor.may_i?("tardis.steer")).to be true

      actor.roles.destroy(timelord_role)
      expect(actor.may_i?("tardis.enter")).to be false
      expect(actor.may_i?("tardis.steer")).to be false
    end
  end
end