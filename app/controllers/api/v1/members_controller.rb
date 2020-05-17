# frozen_string_literal: true

require 'concerns/http_auth_concern'

class Api::V1::MembersController < ApplicationController
  include HttpAuthConcern

  before_action :authenticate, except: %i[index show]
  before_action :set_member, only: %i[show update destroy]

  # GET /api/v1/members
  def index
    @members = Member.all

    render json: @members
  end

  # GET /api/v1/members/1
  def show
    render json: @member
  end

  # POST /api/v1/members
  def create
    @member = Member.new(member_params)

    if @member.save
      render json: @member,
             status: :created,
             location: api_v1_member_url(@member)
    else
      render json: @member.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/members/1
  def update
    if @member.update(member_params)
      render json: @member
    else
      render json: @member.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/members/1
  def destroy
    @member.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_member
    @member = Member.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def member_params
    params.require(:member).permit(:name)
  end
end
