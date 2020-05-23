# frozen_string_literal: true

module Types
  class ChannelType < Types::BaseObject
    implements Types::RecordType

    field :channel, String,
          'Identifier for this channel, unique by platform',
          null: false
    field :platform, PlatformType,
          'Platform that owns this channel',
          null: false
    field :member, MemberType,
          'Member that owns this channel',
          null: true
  end
end
