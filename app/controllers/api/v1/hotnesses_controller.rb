# frozen_string_literal: true

require 'concerns/http_auth_concern'
require 'utils/transform'

class Api::V1::HotnessesController < ApplicationController
  include HttpAuthConcern

  before_action :authenticate, except: %i[show]
  before_action :set_hotness, only: %i[show update destroy]
  before_action :filter, only: %i[index]
  before_action :pagination, only: %i[index]

  # GET /api/v1/hotnesses
  def index
    render json: { hotnesses: @hotnesses.map(&method(:transform)),
                   total: @hotnesses.total_count, }
  end

  # GET /api/v1/hotnesses/1
  def show
    render json: @hotness
  end

  # POST /api/v1/hotnesses
  def create
    @hotness = Hotness.new(hotness_params)

    if @hotness.save
      render json: @hotness,
             status: :created,
             location: api_v1_hotness_url(@hotness)
    else
      render json: @hotness.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/hotnesses/1
  def update
    if @hotness.update(hotness_params)
      render json: @hotness
    else
      render json: @hotness.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/hotnesses/1
  def destroy
    @hotness.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_hotness
    @hotness = Hotness.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def hotness_params
    format params.require(:hotness).permit(:watching, :like, :live)
  end

  def filter
    @hotnesses = Hotness.of_lives(params[:lives])
  end

  def pagination
    @hotnesses = @hotnesses.page(params.fetch(:page, 1))
                           .per(params.fetch(:limit, 500).to_i.clamp(0, 1000))
  end

  def format(hotness_params)
    hotness_params.to_h.each_with_object({}) do |(key, value), hash|
      hash[key] = case key
                  when 'live'
                    Transform.record! value, key.to_s.classify.constantize
                  when 'watching', 'like'
                    Transform.integer! value
                  else
                    value
                  end
    end
  end

  def transform(hotness)
    keys_to_select = %i[live_id watching like created_at]
    hotness.as_json(only: keys_to_select)
  end
end
