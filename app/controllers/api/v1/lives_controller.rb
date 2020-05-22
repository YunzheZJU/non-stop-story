# frozen_string_literal: true

require 'concerns/http_auth_concern'
require 'utils/transform'

class Api::V1::LivesController < ApplicationController
  include HttpAuthConcern

  before_action :authenticate, except: %i[show ended current scheduled]
  before_action :set_live, only: %i[show update destroy]
  before_action :filter, only: %i[ended current scheduled]
  before_action :pagination, only: %i[ended current scheduled]

  def index
    @lives = Live.all
    render json: @lives
  end

  def show
    render json: @live
  end

  def update
    if @live.update live_params
      render json: @live
    else
      render json: @live.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @live.destroy!
  end

  def create
    @live = Live.new live_params
    if @live.save
      render json: @live, status: :created, location: api_v1_live_url(@live)
    else
      render json: @live.errors, status: :unprocessable_entity
    end
  end

  def ended
    # TODO: Group by channel, Order by
    @lives = @lives.ended
                   .order(start_at: :desc)
                   .all
    render json: { lives: @lives.map(&method(:transform)),
                   total: @lives.total_count }
  end

  def current
    @lives = @lives.not_ended
                   .order(start_at: :asc)
                   .start_before(Time.now)
                   .all
    render json: { lives: @lives.map(&method(:transform)),
                   total: @lives.total_count }
  end

  def scheduled
    @lives = @lives.not_ended
                   .order(start_at: :asc)
                   .start_after(Time.now)
                   .all
    render json: { lives: @lives.map(&method(:transform)),
                   total: @lives.total_count }
  end

  private

  def set_live
    @live = Live.find params[:id]
  end

  def live_params
    format params.require(:live).permit(
      :title, :start_at, :duration, :channel, :room, :video
    )
  end

  def format(live_params) # rubocop:todo Metrics/MethodLength
    live_params.to_h.each_with_object({}) do |(key, value), hash|
      hash[key] = case key
                  when 'start_at'
                    Transform.datetime! value
                  when 'duration'
                    Transform.integer! value
                  when 'channel', 'room', 'video'
                    Transform.record! value, key.to_s.classify.constantize
                  else
                    value
                  end
    end
  end

  def filter
    @lives = Live.includes(:channel, :video, room: :platform)
                 .of_channels(params[:channels])
  end

  def pagination
    pagination_params = params.permit :page, :limit
    @lives = @lives.page(pagination_params.fetch(:page, 1))
                   .per(pagination_params.fetch(:limit, 30))
  end

  def transform(live)
    { id: live.id,
      title: live.title,
      duration: live.duration,
      start_at: live.start_at,
      room: live.room.room,
      platform: live.room.platform.platform,
      channel: live.channel.channel,
      video: live.video&.video }
  end
end
