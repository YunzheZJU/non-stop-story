# frozen_string_literal: true

module Types
  class LiveType < Types::BaseObject
    implements Types::RecordType

    field :title, String,
          'Title of this live',
          null: false
    field :start_at, GraphQL::Types::ISO8601DateTime,
          'Time when this live started',
          null: false, camelize: false
    field :duration, Integer,
          'Duration of this live, if is has ended',
          null: true
    field :channel, ChannelType,
          'Channel that opened this live',
          null: false
    field :room, RoomType,
          'Room that hosts/hosted this live',
          null: false
  end
end
