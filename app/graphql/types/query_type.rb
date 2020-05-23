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

    field :platforms, PlatformType.connection_type, null: false do
      description 'Query for a list of platforms'
    end

    field :member, MemberType, null: false do
      description 'Query for a specific Member'
      argument :id, ID, required: true
    end

    field :members, MemberType.connection_type, null: false do
      description 'Query for a list of members'
    end

    field :channel, ChannelType, null: false do
      description 'Query for a specific Channel'
      argument :id, ID, required: true
    end

    field :channels, ChannelType.connection_type, null: false do
      description 'Query for a list of channels'
    end

    field :room, RoomType, null: false do
      description 'Query for a specific Room'
      argument :id, ID, required: true
    end

    field :rooms, RoomType.connection_type, null: false do
      description 'Query for a list of rooms'
    end

    field :live, LiveType, null: false do
      description 'Query for a specific Live'
      argument :id, ID, required: true
    end

    field :lives, LiveType.connection_type, null: false do
      description 'Query for a list of lives at a specific status'
      argument :status, LiveStatusType, required: false
    end

    def platform(id:)
      Platform.find(id)
    end

    def platforms
      Platform.all
    end

    def member(id:)
      Member.find(id)
    end

    def members
      Member.all
    end

    def channel(id:)
      Channel.find(id)
    end

    def channels
      Channel.all
    end

    def room(id:)
      Room.find(id)
    end

    def rooms
      Room.all
    end

    def live(id:)
      Live.find(id)
    end

    def lives(status: nil)
      lives = Live.includes(:channel, :video, room: :platform)

      return lives.all if status.nil?

      lives.method(status.downcase.to_s).call
           .order(start_at: status == 'ENDED' ? :desc : :asc)
    end
  end
end
