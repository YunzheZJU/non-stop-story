# frozen_string_literal: true

require 'utils/network'
require 'utils/transform'

class MembersTrackJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    MembersTrackJob.set(
      wait: Rails.configuration.job[:members_track][:interval].seconds
    ).perform_later

    Rails.configuration.worker[:members_track].each_key do |platform_val|
      request_and_sync Platform.find_by_platform(platform_val), Member.active
    end
  end

  def request_and_sync(platform, member)
    return unless platform

    channels_by_worker(platform, member).each do |(worker, _index), channels|
      response = Network.get_videos(worker, channels)

      Channel.where(channel: response.keys).find_each do |channel|
        MembersTrackJob.update_member channel.member, response[channel.channel]
      end
    end
  end

  def channels_by_worker(platform, member)
    workers = Rails.configuration
                   .worker[:members_track][platform.platform.to_sym]
    channels = Channel.of_platforms(platform)
                      .of_members(member)
                      .pluck(:channel)
    Transform.allocate(workers, channels)
  end

  class << self
    def update_member(member, channel_info)
      member.update!(
        avatar: channel_info['avatar']
      )
    end
  end
end
