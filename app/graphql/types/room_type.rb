# frozen_string_literal: true

module Types
  class RoomType < Types::BaseObject
    implements Types::RecordType

    field :room, String,
          'Identifier for this room, unique by platform',
          null: false
    field :platform, PlatformType,
          'Platform that owns this room',
          null: false
  end
end
