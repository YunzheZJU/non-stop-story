# frozen_string_literal: true

require 'test_helper'

class GraphqlTest < ActionDispatch::IntegrationTest
  test 'get schema' do
    query_string = <<-GRAPHQL
      {
        __schema {
          types {
            name
          }
        }
      }
    GRAPHQL
    schema = NonStopStorySchema.execute(query_string)
    assert_not_nil schema['data']
    post '/graphql', as: :json
    assert_response :success
  end
end
