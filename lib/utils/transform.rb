# frozen_string_literal: true

class Transform
  class << self
    def allocate(workers, channels)
      array = workers.map.with_index do |worker, index|
        [
          worker,
          channels.values_at(*index.step(channels.size - 1, workers.size).to_a)
        ]
      end
      array.reject! { |_w, c| c.empty? }
      array.to_h
    end

    def integer!(param)
      param.to_i
    end

    def datetime!(param)
      Time.parse param
    end

    def record!(param, model)
      model.find param
    end
  end
end
