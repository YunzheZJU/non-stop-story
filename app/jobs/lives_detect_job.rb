# frozen_string_literal: true

require 'utils/network'
require 'utils/transform'

class LivesDetectJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    LivesDetectJob.set(
      wait: Rails.configuration.job[:lives_detect][:interval].seconds
    ).perform_later

    Rails.configuration.worker[:lives_detect].keys.each do |platform_val|
      request_and_sync Platform.find_by_platform(platform_val), Member.active
    end
  end

  def request_and_sync(platform, member)
    return unless platform

    LivesDetectJob.channels_by_worker(platform, member)
                  .each do |(worker, _index), channels|
      response = Network.get_videos(worker, channels)

      Channel.where(channel: response.keys).find_each do |channel|
        LivesDetectJob.sync_live_rooms channel, response[channel.channel]
      end
    end
  end

  class << self
    def channels_by_worker(platform, member)
      workers = Rails.configuration
                     .worker[:lives_detect][platform.platform.to_sym]
      channels = Channel.of_platforms(platform)
                        .of_members(member)
                        .pluck(:channel)
      Transform.allocate(workers, channels)
    end

    def sync_live_rooms(channel, live_infos)
      room_vals = live_infos.keys
      open_room_vals = Room.open(channel).pluck(:room)

      create_new_lives select(live_infos, room_vals - open_room_vals), channel
      update_lives select(live_infos, room_vals & open_room_vals)
    end

    def create_new_lives(live_infos, channel)
      live_infos.each_pair do |room_val, live_info|
        room = Room.find_or_create_by!(room: room_val,
                                       platform: channel.platform)

        next if room.lives.active.take

        Live.create!(title: live_info['title'],
                     start_at: Time.at(live_info['startAt'] ||
                                         Time.current.to_i),
                     cover: live_info['cover'], channel: channel, room: room)
      end
    end

    def update_lives(live_infos)
      Live.not_ended.joins(:room).includes(:room)
          .merge(Room.where(room: live_infos.keys)).find_each do |live|
        live_info = live_infos[live.room.room]

        live.update!(
          title: live_info['title'],
          cover: live_info['cover'],
          start_at: cal_start_at(live_info['startAt'], live.start_at)
        )
      end
    end

    private

    def select(live_infos, room_vals)
      live_infos.select { |room_val| room_vals.include? room_val }
    end

    def cal_start_at(new_val, old_val)
      new_val ? Time.at(new_val) : [old_val, Time.current].min
    end
  end
end
