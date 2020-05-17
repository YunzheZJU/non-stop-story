# frozen_string_literal: true

class Api::V1::PlatformsController < ApplicationController
  before_action :set_platform, only: %i[show update destroy]

  # GET /api/v1/platforms
  def index
    @platforms = Platform.all

    render json: @platforms
  end

  # GET /api/v1/platforms/1
  def show
    render json: @platform
  end

  # POST /api/v1/platforms
  def create
    @platform = Platform.new(platform_params)

    if @platform.save
      render json: @platform,
             status: :created,
             location: api_v1_platform_url(@platform)
    else
      render json: @platform.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/platforms/1
  def update
    if @platform.update(platform_params)
      render json: @platform
    else
      render json: @platform.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/platforms/1
  def destroy
    @platform.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_platform
    @platform = Platform.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def platform_params
    params.require(:platform).permit(:platform)
  end
end
