# frozen_string_literal: true

class Api::V1::LivesController < ApplicationController
  before_action :set_live, only: %i[show update destroy]
  before_action :filter, only: %i[ended current scheduled]

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

  def transform(live)
    { id: live.id,
      title: live.title,
      duration: live.duration,
      start_at: live.start_at.iso8601,
      room: live.room.room,
      channel: live.channel.channel,
      video: live.video&.video }
  end

  def ended
    # TODO: Group by channel, Order by start_at, Page, Limit
    @lives = @lives.ended
                   .all
                   .map(&method(:transform))
    render json: @lives
  end

  def current
    @lives = @lives.not_ended
                   .start_before(Time.now)
                   .all
                   .map(&method(:transform))
    render json: @lives
  end

  def scheduled
    @lives = @lives.not_ended
                   .start_after(Time.now)
                   .all
                   .map(&method(:transform))
    render json: @lives
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
                    datetime value
                  when 'duration'
                    integer value
                  when 'channel', 'room', 'video'
                    record value, key.to_s.classify.constantize
                  else
                    value
                  end
    end
  end

  def integer(param)
    param.to_i
  end

  def datetime(param)
    Time.parse param
  end

  def record(param, modal)
    modal.find param
  end

  def filter
    @lives = Live.of_channels(params[:channels])
  end
end
