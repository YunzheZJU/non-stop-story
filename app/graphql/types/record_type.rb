# frozen_string_literal: true

module Types
  module RecordType
    include Types::BaseInterface
    field :id, ID,
          'Unique identifier for this record in the table',
          null: false
    field :created_at, GraphQL::Types::ISO8601DateTime,
          'Time when this record was created',
          null: false, camelize: false
    field :updated_at, GraphQL::Types::ISO8601DateTime,
          'Time when this record was last updated',
          null: false, camelize: false
  end
end
