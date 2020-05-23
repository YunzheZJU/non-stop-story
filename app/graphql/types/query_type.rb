# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    description 'The query root of this schema'
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :platform, PlatformType, null: false do
      description 'Query for a specific Platform'
      argument :id, ID, required: true
    end

    field :member, MemberType, null: false do
      description 'Query for a specific Member'
      argument :id, ID, required: true
    end

    field :channel, ChannelType, null: false do
      description 'Query for a specific Channel'
      argument :id, ID, required: true
    end

    field :room, RoomType, null: false do
      description 'Query for a specific Room'
      argument :id, ID, required: true
    end

    field :live, LiveType, null: false do
      description 'Query for a specific Live'
      argument :id, ID, required: true
    end

    def platform(id:)
      Platform.find(id)
    end

    def member(id:)
      Member.find(id)
    end

    def channel(id:)
      Channel.find(id)
    end

    def room(id:)
      Room.find(id)
    end

    def live(id:)
      Live.find(id)
    end
  end
end
