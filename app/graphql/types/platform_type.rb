# frozen_string_literal: true

module Types
  class PlatformType < Types::BaseObject
    implements Types::RecordType

    field :platform, String,
          'Identifier for this Platform',
          null: false
  end
end
