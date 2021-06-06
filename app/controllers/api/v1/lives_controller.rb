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
                   total: @lives.total_count, }
  end

  def current
    @lives = @lives.current
                   .order(start_at: :asc)
                   .all
    render json: { lives: @lives.map(&method(:transform)),
                   total: @lives.total_count, }
  end

  def scheduled
    @lives = @lives.scheduled
                   .order(start_at: :asc)
                   .all
    render json: { lives: @lives.map(&method(:transform)),
                   total: @lives.total_count, }
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

  # rubocop:todo Metrics/MethodLength
  def format(live_params)
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

  # rubocop:enable Metrics/MethodLength

  def filter
    @lives = Live.eager_load(:channel, :video, room: :platform)
                 .of_channels(params[:channels])
    %i[start_before start_after].each do |key|
      param = params[key]
      @lives = @lives.send(key, Time.at(param.to_i)) if param
    end
  end

  def pagination
    @lives = @lives.page(params.fetch(:page, 1))
                   .per(params.fetch(:limit, 30).to_i.clamp(0, 100))
  end

  def transform(live)
    keys_to_select = %i[id title duration start_at channel_id cover created_at]
    live.as_json(only: keys_to_select)
        .merge(room: live.room.room,
               platform: live.room.platform.platform,
               channel: live.channel.channel,
               video: live.video&.video)
  end
end
