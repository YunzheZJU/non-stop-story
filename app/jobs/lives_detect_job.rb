# frozen_string_literal: true

require 'utils/network'
require 'utils/transform'

class LivesDetectJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    LivesDetectJob.set(wait: 60.seconds).perform_later

    %w[youtube bilibili].each do |platform_val|
      request_and_sync Platform.find_by_platform(platform_val)
    end
  end

  def request_and_sync(platform)
    LivesDetectJob.channels_by_worker(platform).each do |worker, channels|
      response = Network.get_videos(worker, channels)

      Channel.where(channel: response.keys).find_each do |channel|
        LivesDetectJob.sync_live_rooms channel, response[channel.channel]
      end
    end
  end

  class << self
    def channels_by_worker(platform)
      # workers = %w[w1 w2 w3]
      workers = Rails.configuration.worker[platform.platform]
      # channels = %w[c1 c2 c3 c4 c5 c6 c7]
      channels = Channel.of_platforms(platform).pluck(:channel)
      # { 'w1' => %w[c1 c4 c7], 'w2' => %w[c2 c5], 'w3' => %w[c3 c6] }
      Transform.allocate(workers, channels)
    end

    def sync_live_rooms(channel, live_infos)
      room_vals = live_infos.keys
      open_room_vals = Room.open(channel).pluck(:room)

      close_or_delete_lives open_room_vals - room_vals
      create_lives select(live_infos, room_vals - open_room_vals), channel
      update_lives select(live_infos, room_vals & open_room_vals)
    end

    def close_or_delete_lives(room_vals)
      room_vals.each do |room_val|
        room = Room.find_by_room(room_val)
        live = Live.find_by_room_id_and_duration(room, nil)

        if live.start_at <= Time.now
          live.update! duration: (Time.now - live.start_at).to_i
        else
          live.destroy!
          room.destroy! if room.lives.empty?
        end
      end
    end

    def create_lives(live_infos, channel)
      live_infos.to_a.each do |room_val, live_info|
        room = Room.find_or_create_by!(
          room: room_val,
          platform: channel.platform
        )
        Live.create!(title: live_info['title'],
                     start_at: Time.at(live_info['startAt'] || Time.now.to_i),
                     channel: channel,
                     room: room)
      end
    end

    def update_lives(live_infos)
      Live.includes(:room, :channel)
          .where(lives: { duration: nil },
                 rooms: { room: live_infos.keys }).find_each do |live|
        live_info = live_infos[live.room.room]
        start_at = live_info['startAt']

        live.update!(
          title: live_info['title'],
          start_at: start_at ? Time.at(start_at) : [live.start_at, Time.now].min
        )
      end
    end

    private

    def select(live_infos, room_vals)
      live_infos.select { |room_val| room_vals.include? room_val }
    end
  end
end
