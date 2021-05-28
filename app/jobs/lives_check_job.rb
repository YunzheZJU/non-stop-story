# frozen_string_literal: true

require 'utils/network'
require 'utils/transform'

class LivesCheckJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    interval = Rails.configuration.job[:lives_check][:interval].seconds
    LivesCheckJob.set(wait: interval).perform_later

    Rails.configuration.worker[:lives_check].keys.each do |platform_val|
      request_and_sync Platform.find_by_platform(platform_val)
    end
  end

  def request_and_sync(platform)
    return unless platform

    LivesCheckJob.rooms_by_worker(platform)
                 .each do |(worker, _index), rooms|
      response = Network.get_videos(worker, rooms)

      Room.where(room: response.keys).lives.active.find_each do |live|
        LivesCheckJob.sync_live live, response[live.room.room]
      end
    end
  end

  class << self
    def rooms_by_worker(platform)
      workers = Rails.configuration
                     .worker[:lives_check][platform.platform.to_sym]
      rooms = Live.active.select('room').of_platform(platform)
      Transform.allocate(workers, rooms)
    end

    def sync_live(live, live_info)
      live.update!(title: live_info['title'] || live.title,
                   cover: live_info['cover'] || live.cover)

      schedule_live live, live_info
      update_live live, live_info
      close_live live, live_info
      abort_live live, live_info
    end

    def schedule_live(live, live_info)
      return unless live_info['startAt']

      live.update!(duration: nil, start_at: Time.at(live_info['startAt']))
    end

    def update_live(live, live_info)
      return unless live_info['watching'] && live_info['like']

      live.update!(duration: nil, start_at: [Time.current, live.start_at].min)
      # TODO: Insert into LiveStatus
      # LiveStatus.create!(watching: live_info['watching'], live: live,
      #                    like: live_info['like'], timestamp: Time.current)
    end

    def close_live(live, live_info)
      return unless live_info['duration']

      live.update!(duration: live_info['duration'])
    end

    def abort_live(live, live_info)
      return unless live_info['err']

      if live.start_at <= Time.current
        return if live.duration

        return live.update!(duration: (Time.current - live.start_at).to_i)
      end

      room = live.room
      live.destroy
      room.destroy! if room.lives.empty?
    end
  end
end
