# frozen_string_literal: true

module Types
  class LiveStatusType < Types::BaseEnum
    value 'ENDED',
          'Lives that has finished, with a valid duration'
    value 'CURRENT',
          'Lives that is still active, with duration = null and start_at <= now'
    value 'SCHEDULED',
          'Lives that has not started, with duration = null and start_at > now'
  end
end
