# frozen_string_literal: true

module Types
  class MemberType < Types::BaseObject
    implements Types::RecordType

    field :name, String,
          'Official name for this Member',
          null: false
  end
end
