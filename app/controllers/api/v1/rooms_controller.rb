# frozen_string_literal: true

class Api::V1::RoomsController < ApplicationController
  before_action :set_room, only: %i[show update destroy]

  # GET /api/v1/rooms
  def index
    @rooms = Room.all

    render json: @rooms
  end

  # GET /api/v1/rooms/1
  def show
    render json: @room
  end

  # POST /api/v1/rooms
  def create
    @room = Room.new(room_params)

    if @room.save
      render json: @room,
             status: :created,
             location: api_v1_room_url(@room)
    else
      render json: @room.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/rooms/1
  def update
    if @room.update(room_params)
      render json: @room
    else
      render json: @room.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/rooms/1
  def destroy
    @room.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_room
    @room = Room.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def room_params
    format params.require(:room).permit(:room, :platform)
  end

  def format(room_params)
    room_params.to_h.each_with_object({}) do |(key, value), hash|
      hash[key] = case key
                  when 'platform'
                    Transform.record! value, key.to_s.classify.constantize
                  else
                    value
                  end
    end
  end
end
