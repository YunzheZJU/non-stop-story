# frozen_string_literal: true

require 'utils/network'
require 'utils/transform'

class LivesCheckJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    LivesCheckJob.set(
      wait: Rails.configuration.job[:lives_check][:interval].seconds
    ).perform_later

    Rails.configuration.worker[:lives_check].each_key do |platform_val|
      request_and_sync Platform.find_by_platform(platform_val)
    end
  end

  def request_and_sync(platform)
    return unless platform

    LivesCheckJob.rooms_by_worker(platform)
                 .each do |(worker, _index), rooms|
      response = Network.get_videos(worker, rooms)

      Live.active.joins(:room).includes(:room, :channel)
          .merge(Room.where(room: response.keys)).find_each do |live|
        LivesCheckJob.sync_live live, response[live.room.room]
      end
    end
  end

  class << self
    def rooms_by_worker(platform)
      workers = Rails.configuration
                     .worker[:lives_check][platform.platform.to_sym]
      rooms = Room.of_platform(platform).joins(:lives).merge(Live.active)
                  .pluck('room')
      Transform.allocate(workers, rooms)
    end

    def sync_live(live, live_info)
      case live_info['status']
      when 'living'
        update_live live, live_info
      when 'error', 'ended'
        close_live live
      end
    end

    def update_live(live, live_info)
      live.update!(duration: nil)

      return unless live_info['watching'] || live_info['like']

      Hotness.create!(live: live, watching: live_info['watching'], like: live_info['like'])
    end

    def close_live(live)
      if live.start_at <= Time.current
        return live.update!(
          duration: live.duration || (Time.current - live.start_at).to_i
        )
      else
        live.hotnesses.destroy_all
      end

      room = live.room
      live.destroy
      room.destroy! if room.lives.empty?
    end
  end
end
