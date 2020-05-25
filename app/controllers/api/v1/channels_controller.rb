# frozen_string_literal: true

require 'concerns/http_auth_concern'
require 'utils/transform'

class Api::V1::ChannelsController < ApplicationController
  include HttpAuthConcern

  before_action :authenticate, except: %i[index show]
  before_action :set_channel, only: %i[show update destroy]
  before_action :filter, only: :index
  before_action :pagination, only: :index

  # GET /api/v1/channels
  def index
    render json: { channels: @channels.all, total: @channels.total_count }
  end

  # GET /api/v1/channels/1
  def show
    render json: @channel
  end

  # POST /api/v1/channels
  def create
    @channel = Channel.new(channel_params)

    if @channel.save
      render json: @channel,
             status: :created,
             location: api_v1_channel_url(@channel)
    else
      render json: @channel.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/channels/1
  def update
    if @channel.update(channel_params)
      render json: @channel
    else
      render json: @channel.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/channels/1
  def destroy
    @channel.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_channel
    @channel = Channel.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def channel_params
    format params.require(:channel).permit(
      :channel, :platform, :member, :editor
    )
  end

  def filter
    @channels = Channel.includes(:platform, :member)
                       .of_platforms(params[:platforms])
                       .of_members(params[:members])
  end

  def pagination
    @channels = @channels.page(params.fetch(:page, 1))
                         .per(params.fetch(:limit, 30).to_i.clamp(0, 100))
  end

  def format(channel_params)
    channel_params.to_h.each_with_object({}) do |(key, value), hash|
      hash[key] = case key
                  when 'platform', 'member', 'editor'
                    Transform.record! value, key.to_s.classify.constantize
                  else
                    value
                  end
    end
  end
end
