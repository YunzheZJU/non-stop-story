# frozen_string_literal: true

require 'test_helper'

class Api::V1::MembersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @member = members(:test_1)
  end

  test 'should get index' do
    get api_v1_members_url, as: :json
    assert_response :success
  end

  test 'should create member' do
    assert_difference('Member.count') do
      post api_v1_members_url,
           params: { member: { name: 'NewMember' } },
           as: :json
    end

    assert_response 201
  end

  test 'should show member' do
    get api_v1_member_url(@member), as: :json
    assert_response :success
  end

  test 'should update member' do
    patch api_v1_member_url(@member),
          params: { member: { name: 'NewMember' } },
          as: :json
    assert_response 200
  end

  test 'should destroy member' do
    assert_raise(StandardError) do
      delete api_v1_member_url(@member), as: :json
    end
  end
end
