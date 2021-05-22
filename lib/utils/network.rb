# frozen_string_literal: true

require 'json'
require 'net/http'

class Network
  class << self
    def get_videos(worker, channels)
      retry_count = 0
      begin
        res = request(*encode_worker_uri(worker, channels))

        raise "Network error: #{res.code}" unless res.is_a? Net::HTTPSuccess

        JSON.parse(res.body)
      rescue StandardError => e
        Rails.logger.error e.message
        retry if (retry_count += 1) <= 1
        {}
      end
    end

    private

    def encode_worker_uri(worker, channels)
      is_plain_worker = worker.instance_of? String

      uri = URI(is_plain_worker ? worker : worker[:worker])
      uri.query = URI.encode_www_form(channels: channels)

      proxy = begin
                URI(worker[:proxy])
              rescue StandardError
                nil
              end

      [uri, proxy]
    end

    def request(uri, proxy)
      Net::HTTP.start(
        uri.host, uri.port, proxy&.host, proxy&.port,
        open_timeout: 5, read_timeout: 5,
        use_ssl: uri.scheme == 'https', max_retries: 3
      ) do |http|
        http.request Net::HTTP::Get.new(uri, yunzhes: 'PrivateHeader')
      end
    end
  end
end
